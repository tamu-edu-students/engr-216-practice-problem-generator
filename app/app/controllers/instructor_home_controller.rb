class InstructorHomeController < ApplicationController
  before_action :ensure_instructor
  before_action :set_types

  def index
    @instructor = current_user
    @logout_path = logout_path
    @profile_path = user_path(@instructor)
    @custom_template_path = custom_template_path
    @instructor_home_summary_path = instructor_home_summary_path
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
    @students = User.where(role: 0) # Assuming 0 represents the student role
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

  def set_topics
    @topics = Topic.all
  end

  def set_types
    @types = Type.all
  end
end
