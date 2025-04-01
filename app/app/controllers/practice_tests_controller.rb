class PracticeTestsController < ApplicationController
  before_action :set_topics, :set_types, only: [:practice_test_form, :create]
  before_action :set_selected_topics_and_types, only: [:practice_test_generation, :submit_practice_test]

  def practice_test_form
  end

  def practice_test_generation
    questions_scope = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids)
  
    if questions_scope.count == 0
      flash[:alert] = "No questions available for the selected criteria."
      redirect_to practice_test_form_path and return
    end
  
    selected_questions = questions_scope.order("RANDOM()").limit(10)
  
    @exam_questions = selected_questions.map do |question|
      variable_values = generate_random_values(question.variables, question.variable_ranges, question.variable_decimals)

      formatted_text = if question.template_text.present?
                         format_template_text(question.template_text, variable_values, question.variable_decimals, question.variables)
                       else
                         question.text
                       end
  
      solution = evaluate_equation(question.equation, variable_values) || question.answer

      if question.round_decimals.present? && solution.to_s.match?(/\A-?\d+(\.\d+)?\Z/)
        solution = solution.to_f.round(question.round_decimals)
      end
  
      {
        question_id: question.id,
        question_text: formatted_text,
        question_img: question.img,
        solution: solution,
        round_decimals: question.round_decimals,
        explanation:   question.explanation,
        question_type: question.type.type_name,
        answer_choices: question.type.type_name == "Multiple choice" ? question.answer_choices.map { |ac| { text: ac.choice_text, correct: ac.correct } } : []
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
  
      question_id     = q[:question_id]
      question_text   = q[:question_text].to_s.presence || "[No question text]"
      question_img    = q[:question_img]
      solution        = q[:solution].to_s.presence || "[No solution available]"
      round_decimals  = q[:round_decimals]
      explanation     = q[:explanation]
      question_type   = q[:question_type]
      answer_choices  = q[:answer_choices]
  
      submitted_answer = submitted_answers[question_id.to_s].to_s.strip.presence || "[No answer provided]"
  
      is_correct = false
      if question_type == "Multiple choice"

        correct_choice, is_correct = evaluate_multiple_choice(question_type, answer_choices, submitted_answer)
      else
        submitted_value = submitted_answer.to_f if submitted_answer.match?(/\A-?\d+(\.\d+)?\Z/)
        solution_value  = solution.to_f if solution.match?(/\A-?\d+(\.\d+)?\Z/)
  
        if submitted_value && solution_value
          is_correct = (submitted_value - solution_value).abs < 1e-6
        else
          is_correct = submitted_answer.downcase == solution.downcase
        end
      end
  
      if current_user && question_id
        Submission.create!(user_id: current_user.id, question_id: question_id, correct: is_correct)
      end
  
      results << {
        question_id: question_id,
        question_text: question_text,
        question_img: question_img,
        submitted_answer: submitted_answer,
        solution: solution,
        correct: is_correct,
        round_decimals: round_decimals,
        explanation: explanation
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
    @score = test_results[:score] || 0
    @total = test_results[:total] || 0
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
    @selected_topics = Topic.where(topic_id: @selected_topic_ids)

    @selected_type_ids = session[:selected_type_ids] || []
    @selected_types = Type.where(type_id: @selected_type_ids)
  end

  def generate_random_values(variables, variable_ranges = nil, variable_decimals = nil)
    values = {}
    variables.each_with_index do |variable, index|
      if variable_ranges && variable_decimals && variable_ranges[index] && variable_decimals[index]
        range = variable_ranges[index]
        decimals = variable_decimals[index]
        min = range[0].to_f
        max = range[1].to_f
        value = rand * (max - min) + min
        value = value.round(decimals)
      else
        value = rand(1..10)
      end
      values[variable.to_sym] = value
    end
    values
  end

  def format_template_text(template_text, variable_values, variable_decimals = nil, variables = nil)
    return nil if template_text.nil?
    return template_text if variable_values.empty?

    formatted_text = template_text.dup
    variable_names = variables || variable_values.keys.map(&:to_s)
    variable_names.each_with_index do |var, index|
      value = variable_values[var.to_sym]
      formatted_value = if variable_decimals && variable_decimals[index]
                          sprintf("%.#{variable_decimals[index]}f", value)
                        else
                          value.to_s
                        end
      formatted_text.gsub!(/\\\(\s*#{var}\s*\\\)/, formatted_value)
    end
    formatted_text
  end

  def evaluate_equation(equation, values)
    return nil if equation.nil?
  
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

  def evaluate_multiple_choice(question_type, answer_choices, submitted_answer)
    return [nil, false] unless question_type == "Multiple choice"
    
    correct_choice = answer_choices.find { |ac| ac[:correct] }
    is_correct = submitted_answer == correct_choice[:text] if correct_choice
    [correct_choice, is_correct]
  end

  def set_topics
    @topics = Topic.all
  end

  def set_types
    @types = Type.all
  end
end
