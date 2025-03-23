class InstructorHomeController < ApplicationController
  before_action :ensure_instructor # Ensure the user is an instructor
  before_action :set_topics, :set_types, only: [ :index, :custom_template, :create_template ]

  def index
    @instructor = current_user
    @logout_path = logout_path
    @profile_path = user_path(@instructor)
    @custom_template_path = custom_template_path
    @instructor_home_summary_path = instructor_home_summary_path
  end


  def create_template
    topic = Topic.find(params[:topic_id])
    type = Type.find(params[:type_id])
    variables = params[:variables].split(",").map(&:strip)
    variable_ranges = params[:variable_ranges].split(",").map do |range_str|
      bounds = range_str.split("-").map(&:strip)
      [bounds[0].to_i, bounds[1].to_i]
    end
    variable_decimals = params[:variable_decimals].split(",").map { |s| s.strip.to_i }

    Question.create!(
      topic: topic,
      type: type,
      template_text: params[:template_text],
      equation: params[:equation],
      variables: variables,
      answer: params[:answer],
      round_decimals: params[:round_decimals],
      explanation: params[:explanation],
      variable_ranges: variable_ranges,
      variable_decimals: variable_decimals
    )

    flash[:notice] = "Question template created successfully!"
    redirect_to instructor_home_path
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
    unless current_user&.instructor?
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
