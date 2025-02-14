class InstructorHomeController < ApplicationController
  before_action :ensure_instructor # Ensure the user is an instructor
  before_action :set_topics, :set_types, only: [ :index, :custom_template, :create_template ]

  def index
    @instructor = current_user
    @logout_path = logout_path
    @profile_path = user_path(@instructor)
    @custom_template_path = custom_template_path
  end

  def custom_template
    #
  end


  def create_template
    topic = Topic.find(params[:topic_id])
    type = Type.find(params[:type_id])
    variables = params[:variables].split(",").map(&:strip)

    Question.create!(
      topic: topic,
      type: type,
      template_text: params[:template_text],
      equation: params[:equation],
      variables: variables,
      answer: params[:answer]
    )

    flash[:notice] = "Question template created successfully!"
    redirect_to instructor_home_path
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
