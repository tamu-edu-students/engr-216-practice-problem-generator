class PracticeTestsController < ApplicationController
  before_action :set_topics, :set_types, only: [ :practice_test_form, :create ]
  before_action :set_selected_topics_and_types, only: [ :practice_test_generation, :submit_practice_test ]

  def practice_test_form
    # renders the form where the user selects topics/types.
  end

  def practice_test_generation
    questions_scope = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids)

    if questions_scope.count == 0
      flash[:alert] = "No questions available for the selected criteria."
      redirect_to practice_test_form_path and return
    end

    selected_questions = questions_scope.order("RANDOM()").limit(10)

    @exam_questions = selected_questions.map do |question|
      variable_values = generate_random_values(question.variables)
      formatted_text = if question.template_text.present?
                         format_template_text(question.template_text, variable_values)
      else
                         question.text
      end
      solution = evaluate_equation(question.equation, variable_values) || question.answer

      {
        question_id:   question.id,
        question_text: formatted_text,
        question_img:  question.img,
        solution:      solution
      }
    end

    session[:exam_questions] = @exam_questions
  end

  def submit_practice_test
    submitted_answers = params[:answers] || {}
    exam_questions = session[:exam_questions] || []
    results = []
    score = 0

    exam_questions.each do |q|
      q = q.deep_symbolize_keys

      question_id   = q[:question_id]
      question_text = q[:question_text].to_s.presence || "[No question text]"
      question_img  = q[:question_img]
      solution      = q[:solution].to_s.presence || "[No solution available]"

      submitted_answer = submitted_answers[question_id.to_s].to_s.strip.presence || "[No answer provided]"

      submitted_value = submitted_answer.to_f if submitted_answer.match?(/\A-?\d+(\.\d+)?\Z/)
      solution_value  = solution.to_f if solution.match?(/\A-?\d+(\.\d+)?\Z/)

      is_correct = false
      if submitted_value && solution_value
        is_correct = (submitted_value - solution_value).abs < 1e-6
      else
        is_correct = submitted_answer.downcase == solution.downcase
      end

      if current_user && question_id
        Submission.create!(user_id: current_user.id, question_id: question_id, correct: is_correct)
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

    session.delete(:exam_questions)
    redirect_to practice_test_result_path
  end

  def result
    test_results = session[:test_results]&.deep_symbolize_keys || { score: 0, total: 0, results: [] }
    @score   = test_results[:score]   || 0
    @total   = test_results[:total]   || 0
    @results = test_results[:results] || []
  end

  def create
    selected_topic_ids = params[:topic_ids] || []
    session[:selected_topic_ids] = selected_topic_ids

    selected_type_ids = params[:type_ids] || []
    session[:selected_type_ids] = selected_type_ids

    redirect_to practice_test_generation_path, notice: "Question topics and types saved in session!"
  end

  private

  def set_selected_topics_and_types
    @selected_topic_ids = session[:selected_topic_ids] || []
    @selected_topics    = Topic.where(topic_id: @selected_topic_ids)

    @selected_type_ids  = session[:selected_type_ids] || []
    @selected_types     = Type.where(type_id: @selected_type_ids)
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
    rescue StandardError, SyntaxError => e
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
