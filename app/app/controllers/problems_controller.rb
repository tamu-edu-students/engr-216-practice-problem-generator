class ProblemsController < ApplicationController
  before_action :set_topics, :set_types, only: [ :problem_form, :create ]
  before_action :set_selected_topics_and_types, only: [ :problem_generation, :submit_answer ]

  def problem_form
    session.delete(:submitted_answer)
    session.delete(:solution)
    session.delete(:question_text)
    session.delete(:question_img)
    session.delete(:question_id)
    session.delete(:try_another_problem)
    session.delete(:is_correct)
    session.delete(:explanation)
  end

  def problem_generation
    if session[:try_another_problem]
      session.delete(:submitted_answer)
      session.delete(:solution)
      session.delete(:question_text)
      session.delete(:question_img)
      session.delete(:question_id)
      session.delete(:try_another_problem)
      session.delete(:is_correct)
      session.delete(:explanation)
      session.delete(:round_decimals)
    end

    if session[:question_id].present?
      @question = Question.find(session[:question_id])
      @question_text = session[:question_text]
      @solution = session[:solution]
      @question_img = session[:question_img]
      @submitted_answer = session[:submitted_answer]
      @is_correct = session[:is_correct]
      @explanation = session[:explanation]
      @round_decimals = session[:round_decimals]

    else
      @question = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids).order("RANDOM()").first
    
      if @question.present?
        @variable_values = generate_random_values(@question.variables)
        @question_text = format_template_text(@question.template_text, @variable_values) if @question.template_text.present?
        @solution = evaluate_equation(@question.equation, @variable_values) || @question.answer
    
        if @solution.is_a?(Float) && @question.round_decimals.present?
          @solution = @solution.round(@question.round_decimals)
        end
    
        session[:solution] = @solution
        session[:question_text] = @question_text
        session[:question_img] = @question_img
        session[:question_id] = @question.id
        session[:explanation] = @question.explanation
        session[:round_decimals] = @question.round_decimals
    
      else
        flash[:alert] = "No questions found with the selected topics and types. Please try again."
      end
    end
  end

  def submit_answer
    @submitted_answer = params[:answer].to_s.strip
    @solution = session[:solution]
    @question_text = session[:question_text]
    @question_img = session[:question_img]
    question_id = session[:question_id]
    user = current_user

    submitted_value = if @submitted_answer.to_i.to_s == @submitted_answer
                        @submitted_answer.to_i
    else
                        @submitted_answer.to_f
    end

    solution_value = if @solution.to_i.to_s == @solution.to_s
                        @solution.to_i
    else
                        @solution.to_f
    end

    @is_correct = submitted_value == solution_value

    if user && question_id
      Submission.create!(user_id: user.id, question_id: question_id, correct: @is_correct ? true : false)
    else
      Rails.logger.error "Submission failed: Missing information"
    end


    @question = Question.find_by(id: question_id)
    if @question
      session[:explanation] = @question.explanation
    end
    session[:submitted_answer] = @submitted_answer
    session[:is_correct] = @is_correct
    redirect_to :problem_generation
  end

  def try_another_problem
    session[:try_another_problem] = true
    redirect_to problem_generation_path
  end

  def create
      selected_topic_ids = params[:topic_ids] || []
      session[:selected_topic_ids] = selected_topic_ids

      selected_type_ids = params[:type_ids] || []
      session[:selected_type_ids] = selected_type_ids

      redirect_to problem_generation_path, notice: "Question topics and types saved in session!"
    end

    private
    def set_selected_topics_and_types
      @selected_topic_ids = session[:selected_topic_ids] || []
      @selected_topics = Topic.where(topic_id: @selected_topic_ids)

      @selected_type_ids = session[:selected_type_ids] || []
      @selected_types = Type.where(type_id: @selected_type_ids)
    end

    def generate_random_values(variables)
      values = {}
      variables.each do |variable|
        values[variable.to_sym] = rand(1..10)
      end
      values
    end

    def format_template_text(template_text, variable_values)
      return nil if template_text.nil?
      return template_text if variable_values.empty?

      formatted_text = template_text.dup
      variable_values.each do |variable, value|
        formatted_text.gsub!(/\\\(\s*#{variable}\s*\\\)/, value.to_s)
      end

      formatted_text
    end

    # Solves equation given values for variables
    def evaluate_equation(equation, values)
      return nil if equation.nil? || values.empty?

      expression = equation.dup
      values.each do |variable, value|
        expression.gsub!(variable.to_s, value.to_f.to_s)
      end

      begin
        result = eval(expression)
        result = nil if result.infinite?
      rescue StandardError, SyntaxError => e
        Rails.logger.error "Equation evaluation error: #{e.message}"
        result = nil
      end

      result
    end

    def set_topics
      @topics = Topic.all
    end

    def set_types
      @types = Type.all
    end
end
