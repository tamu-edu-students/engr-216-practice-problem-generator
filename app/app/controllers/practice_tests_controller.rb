class PracticeTestsController < ApplicationController
  before_action :set_topics, :set_types, only: [:practice_test_form, :create]
  before_action :set_selected_topics_and_types, only: [:practice_test_generation, :submit_practice_test]

  def practice_test_form
    Rails.logger.debug "Rendering practice_test_form."
    # Renders the form where the user selects topics/types.
  end

  def practice_test_generation
    Rails.logger.debug "Practice Test Generation: Selected Topics: #{@selected_topic_ids.inspect}, Selected Types: #{@selected_type_ids.inspect}"
    
    # Find questions matching the selected topics and types
    questions_scope = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids)
    
    if questions_scope.count == 0
      Rails.logger.debug "No questions available for the selected topics/types."
      flash[:alert] = "No questions available for the selected criteria. Please select different topics/types."
      redirect_to practice_test_form_path and return
    end

    # Select up to 10 random questions (if fewer than 10 are available, select all)
    selected_questions = questions_scope.order("RANDOM()").limit(10)

    # Build an array of question details for the exam
    @exam_questions = selected_questions.map do |question|
      variable_values = generate_random_values(question.variables)
      formatted_text = if question.template_text.present?
                         format_template_text(question.template_text, variable_values)
                       else
                         question.text
                       end
      solution = evaluate_equation(question.equation, variable_values) || question.answer

      Rails.logger.debug "Generated exam question: id: #{question.id}, text: #{formatted_text}, solution: #{solution}"

      {
        question_id:   question.id,
        question_text: formatted_text,
        question_img:  question.img,
        solution:      solution
      }
    end

    # Store exam questions in session to be used when grading
    session[:exam_questions] = @exam_questions
    Rails.logger.debug "Exam questions stored in session: #{session[:exam_questions].inspect}"
  end

  def submit_practice_test
    submitted_answers = params[:answers] || {}  # Hash with keys = question IDs
    Rails.logger.debug "Submitted answers params: #{submitted_answers.inspect}"

    exam_questions = session[:exam_questions] || []
    Rails.logger.debug "Exam questions from session: #{exam_questions.inspect}"

    results = []
    score = 0
  
    exam_questions.each do |q|
      q = q.deep_symbolize_keys  # Ensures all keys are symbols
      question_id   = q[:question_id]
      question_text = q[:question_text]
      question_img  = q[:question_img]
      solution      = q[:solution]
  
      submitted_answer = submitted_answers[question_id.to_s].to_s.strip
      Rails.logger.debug "Processing question_id #{question_id}: submitted_answer: '#{submitted_answer}', solution: '#{solution}'"
  
      if submitted_answer.blank?
        is_correct = false
        Rails.logger.debug "Answer is blank, marking as incorrect."
      else
        submitted_value = submitted_answer.to_f
        solution_value  = solution.to_f
        is_correct = (submitted_value - solution_value).abs < 1e-6
        Rails.logger.debug "Converted values: submitted: #{submitted_value}, solution: #{solution_value}, correct: #{is_correct}"
      end
  
      if current_user && question_id
        Submission.create!(user_id: current_user.id, question_id: question_id, correct: is_correct)
        Rails.logger.debug "Created submission record for user #{current_user.id}, question #{question_id}"
      end
  
      results << {
        question_id:      question_id,
        question_text:    question_text,
        question_img:     question_img,
        submitted_answer: submitted_answer,
        solution:         solution,
        correct:          is_correct
      }
  
      score += 1 if is_correct
    end    
    
    session[:test_results] = {
      score: score,
      total: exam_questions.count,
      results: results
    }
    Rails.logger.debug "Test results stored in session: #{session[:test_results].inspect}"
  
    session.delete(:exam_questions)
    redirect_to practice_test_result_path(format: :html)

  end  

  def result
    test_results = session[:test_results] || { "score" => 0, "total" => 0, "results" => [] }
    @score   = test_results["score"]   || 0
    @total   = test_results["total"]   || 0
    @results = test_results["results"] || []
  end  

  def create
    selected_topic_ids = params[:topic_ids] || []
    session[:selected_topic_ids] = selected_topic_ids

    selected_type_ids = params[:type_ids] || []
    session[:selected_type_ids] = selected_type_ids

    Rails.logger.debug "Create action: selected_topic_ids: #{selected_topic_ids.inspect}, selected_type_ids: #{selected_type_ids.inspect}"
    redirect_to practice_test_generation_path, notice: "Question topics and types saved in session!"
  end

  private

  def set_selected_topics_and_types
    @selected_topic_ids = session[:selected_topic_ids] || []
    @selected_topics    = Topic.where(topic_id: @selected_topic_ids)

    @selected_type_ids  = session[:selected_type_ids] || []
    @selected_types     = Type.where(type_id: @selected_type_ids)
    Rails.logger.debug "set_selected_topics_and_types: Topics IDs: #{@selected_topic_ids.inspect}, Type IDs: #{@selected_type_ids.inspect}"
  end

  def generate_random_values(variables)
    values = {}
    variables.each do |variable|
      values[variable.to_sym] = rand(1..10)
    end
    Rails.logger.debug "Generated random values for variables #{variables.inspect}: #{values.inspect}"
    values
  end

  def format_template_text(template_text, variable_values)
    return nil if template_text.nil?
    return template_text if variable_values.empty?

    formatted_text = template_text.dup
    variable_values.each do |variable, value|
      formatted_text.gsub!(/\\\(\s*#{variable}\s*\\\)/, value.to_s)
    end
    Rails.logger.debug "Formatted template text: '#{formatted_text}' with variables: #{variable_values.inspect}"
    formatted_text
  end

  def evaluate_equation(equation, values)
    return nil if equation.nil? || values.empty?

    expression = equation.dup
    values.each do |variable, value|
      expression.gsub!(variable.to_s, value.to_f.to_s)
    end

    begin
      result = eval(expression)
      result = nil if result.infinite?
      Rails.logger.debug "Evaluated equation '#{equation}' with values #{values.inspect} to get result #{result}"
    rescue StandardError, SyntaxError => e
      Rails.logger.error "Equation evaluation error: #{e.message}"
      result = nil
    end

    result
  end

  def set_topics
    @topics = Topic.all
    Rails.logger.debug "Fetched topics: #{@topics.inspect}"
  end

  def set_types
    @types = Type.all
    Rails.logger.debug "Fetched types: #{@types.inspect}"
  end
end