class InstructorHomeController < ApplicationController
  before_action :ensure_instructor
  before_action :set_types

  def index
    @instructor = current_user
    @logout_path = logout_path
    @profile_path = user_path(@instructor)
    @custom_template_path = custom_template_path
    @instructor_home_summary_path = instructor_home_summary_path
    

    # Added for the instructor dashboard
    @students = User.where(role: 0)
    @total_students = @students.count
    # this is all for getting the accuracy
    total_submissions = 0
    correct_submissions = 0
  
    @students.each do |student|
      total_submissions += student.total_submissions
      correct_submissions += student.correct_submissions
    end
  
    @average_accuracy = if total_submissions > 0
      ((correct_submissions.to_f / total_submissions) * 100).round(2)
    end
    
    # most missed topic, same as before
    @most_missed_topic = Topic.joins(questions: :submissions)
                              .where(submissions: { correct: false })
                              .group("topics.id")
                              .order("COUNT(submissions.id) DESC")
                              .select("topics.*, COUNT(submissions.id) AS missed_count")
                              .first
  
    # getting top performing studetns
    @top_students = @students.joins(:submissions)
                             .select('users.*, AVG(CASE WHEN COUNT(*) > 0 THEN (SUM(CASE WHEN submissions.correct THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) ELSE 0 END) as accuracy')
                             .group('users.id')
                             .order('accuracy DESC')
                             .limit(3)

  end

  def select_template_type
    case params[:question_type]
    when "equation"
      redirect_to custom_template_equation_path
    when "dataset"
      redirect_to custom_template_dataset_path
    when "definition"
      redirect_to custom_template_definition_path
    else
      redirect_to new_template_selector_path, alert: "Please select a valid question type."
    end
  end

  def summary
    @students = User.where(role: 0)
    @my_students = @students.where(instructor_id: current_user.id)

    @most_missed_topic = Topic.joins(questions: :submissions)
                              .where(submissions: { correct: false })
                              .group("topics.id")
                              .order("COUNT(submissions.id) DESC")
                              .select("topics.*, COUNT(submissions.id) AS missed_count")
                              .first
  end

  private

  def ensure_instructor
    unless current_user&.instructor? || current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  # def set_topics
  #   @topics = Topic.all
  # end

  def set_types
    @types = Type.all
  end
end
