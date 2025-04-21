class PracticeController < ApplicationController
  before_action :ensure_not_admin, only: [ :form, :create, :generation, :submit_answer, :submit_test ]
  before_action :set_topics, :set_types, only: [ :form, :create ]
  before_action :set_selected_topics_and_types, only: [ :generation, :submit_answer, :submit_test ]

  def form
    clear_session_data
  end

  def create
    session[:selected_topic_ids] = params[:topic_ids] || []
    session[:selected_type_ids] = params[:type_ids] || []
    session[:practice_test_mode] = params[:practice_test_mode] == "1"
    redirect_to generation_path
  end

  def generation
    session.delete(:exam_questions) if params[:clear_exam].present?
    session.delete(:test_results) if params[:clear_exam].present?

    if @selected_topic_ids.blank? || @selected_type_ids.blank?
      flash[:alert] = "You must select at least one topic and one question type to begin."
      redirect_to practice_form_path and return
    end

    @submitted_answer = session[:submitted_answer]
    @is_correct       = session[:is_correct]
    @solution         = session[:solution]
    @explanation      = session[:explanation]

    if session[:practice_test_mode]
      handle_practice_test_generation
    else
      handle_problem_generation
    end
  end


  def submit_test
    submitted_answers = params[:answers] || {}
    exam_questions = session[:exam_questions] || []
    results = []
    score = 0

    exam_questions.each do |q|
      q = q.deep_symbolize_keys
      question_id     = q[:question_id]
      question_text   = q[:question_text]
      question_img    = q[:question_img]
      solution        = q[:solution]
      round_decimals  = q[:round_decimals]
      explanation     = q[:explanation]
      question_type   = q[:question_type]
      answer_choices  = q[:answer_choices]

      submitted_answer = submitted_answers[question_id.to_s].to_s.strip.presence || "[No answer provided]"
      is_correct = false

      if question_type == "Multiple choice"
        _, is_correct = evaluate_multiple_choice(answer_choices, submitted_answer)
      else
        submitted_value = submitted_answer.to_f if submitted_answer.to_s.match?(/\A-?\d+(\.\d+)?\Z/)
        solution_value  = solution.to_f if solution.to_s.match?(/\A-?\d+(\.\d+)?\Z/)
        is_correct = if submitted_value && solution_value
          (submitted_value - solution_value).abs < 1e-6
        else
          submitted_answer.to_s.downcase == solution.to_s.downcase
        end

      end

      Submission.create!(user_id: current_user.id, question_id: question_id, correct: is_correct) if current_user && question_id

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

    session[:test_results] = { score: score, total: exam_questions.count, results: results }
    session.delete(:exam_questions)
    redirect_to practice_result_path
  end

  def submit_answer
    @submitted_answer = params[:answer].to_s.strip
    @solution = session[:solution]
    @question_text = session[:question_text]
    @question_img = session[:question_img]
    question_id = session[:question_id]
    question_kind = session[:question_kind]
    @question = Question.find_by(id: question_id)

    if @question&.type&.type_name == "Multiple choice"
      selected_choice_id = params[:answer_choice_id].to_i
      selected_choice = @question.answer_choices.find_by(id: selected_choice_id)
      @is_correct = selected_choice&.correct
      @submitted_answer = selected_choice&.choice_text || "[No answer selected]"
      @solution = @question.answer_choices.find_by(correct: true)&.choice_text
    elsif @submitted_answer.blank?
      @submitted_answer = "[No answer provided]"
      @is_correct = false
    else
      case question_kind
      when "definition"
        @is_correct = @submitted_answer.downcase.strip == @solution.to_s.downcase.strip
      when "equation", "dataset"
        submitted_value = parse_number(@submitted_answer)
        solution_value = parse_number(@solution.to_s)
        @is_correct = submitted_value == solution_value
      else
        @is_correct = false
      end
    end

    @is_correct = false if @is_correct.nil?
    Submission.create!(user_id: current_user.id, question_id: @question.id, correct: @is_correct) if current_user && @question

    session[:explanation] = @question&.explanation
    session[:submitted_answer] = @submitted_answer
    session[:is_correct] = @is_correct

    @question = Question.find_by(id: session[:question_id])
    @question_text = session[:question_text]
    @question_img = session[:question_img]
    @round_decimals = session[:round_decimals]
    @explanation = session[:explanation]
    @question_kind = session[:question_kind]

    if @question&.type&.type_name == "Multiple choice"
      @answer_choices = @question.answer_choices.to_a.shuffle.map do |choice|
        {
          id: choice.id,
          text: choice.choice_text,
          correct: choice.correct
        }
      end
    end

    render :generation
  end

  def retake_exam
    session[:exam_questions] = nil
    session[:test_results] = nil
    session[:practice_test_mode] = true
    redirect_to generation_path
  end

  def try_another
    session[:try_another_problem] = true

    unless session[:practice_test_mode]
      session.delete(:submitted_answer)
      session.delete(:is_correct)
      session.delete(:solution)
      session.delete(:explanation)
      session.delete(:question_id)
      session.delete(:question_text)
      session.delete(:question_img)
      session.delete(:round_decimals)
      session.delete(:question_kind)
    end

    redirect_to generation_path
  end

  def result
    test_results = session[:test_results]&.deep_symbolize_keys || { score: 0, total: 0, results: [] }
    @score = test_results[:score] || 0
    @total = test_results[:total] || 0
    @results = test_results[:results] || []
  end

  private

  def handle_practice_test_generation
    questions_scope = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids)

    if questions_scope.count == 0
      flash[:alert] = "No questions available for the selected criteria."
      redirect_to practice_form_path and return
    end

    selected_questions = questions_scope.order("RANDOM()").limit(10)

    @exam_questions = selected_questions.map do |question|
      formatted_text = ""
      solution = ""

      case question.question_kind
      when "equation"
        variable_values = generate_random_values(question.variables, question.variable_ranges, question.variable_decimals)
        formatted_text = format_template_text(question.template_text, variable_values, question.variable_decimals, question.variables)
        solution = evaluate_equation(question.equation, variable_values) || question.answer

      when "dataset"
        dataset = generate_dataset(question.dataset_generator)
        formatted_text = question.template_text.gsub(/\[\s*D\s*\]/, dataset.join(", "))
        solution = compute_dataset_answer(dataset, question.answer_strategy)

      when "definition"
        formatted_text = question.template_text
        solution = question.answer

      else
        formatted_text = question.template_text.presence || "[No question text available]"
        solution = question.answer
      end

      if question.round_decimals.present? && solution.to_s.match?(/\A-?\d+(\.\d+)?\Z/)
        solution = solution.to_f.round(question.round_decimals)
      end

      {
        question_id: question.id,
        question_text: formatted_text,
        question_img: question.img,
        solution: solution,
        round_decimals: question.round_decimals,
        explanation: question.explanation,
        question_type: question.type.type_name,
        answer_choices: question.type.type_name == "Multiple choice" ? question.answer_choices.to_a.shuffle.map { |ac| { text: ac.choice_text, correct: ac.correct } } : []
      }
    end

    session[:exam_questions] = @exam_questions
  end

  def handle_problem_generation
    if session[:try_another_problem]
      session.delete(:try_another_problem)
      session.delete(:question_id)
      session.delete(:submitted_answer)
      session.delete(:is_correct)
      session.delete(:solution)
      session.delete(:explanation)
    end

    if session[:question_id].present?
      @question = Question.find_by(id: session[:question_id])
      if @question.present?
        @question_text     = session[:question_text]
        @solution          = session[:solution]
        @question_img      = session[:question_img]
        @submitted_answer  = session[:submitted_answer]
        @is_correct        = session[:is_correct]
        @explanation       = session[:explanation]
        @round_decimals    = session[:round_decimals]
        @question_kind     = session[:question_kind]
        return
      else
        session.delete(:question_id)
      end
    end

    @question = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids).order("RANDOM()").first

    if @question.present?
      session[:question_id]     = @question.id
      session[:question_kind]   = @question.question_kind
      session[:explanation]     = @question.explanation

      case @question.question_kind
      when "equation"
        @variable_values = generate_random_values(@question.variables, @question.variable_ranges, @question.variable_decimals)
        @question_text   = format_template_text(@question.template_text, @variable_values, @question.variable_decimals, @question.variables)
        @solution        = evaluate_equation(@question.equation, @variable_values)
        @solution        = @solution.round(@question.round_decimals) if @solution.is_a?(Float) && @question.round_decimals.present?
        session[:round_decimals] = @question.round_decimals
      when "dataset"
        @dataset        = generate_dataset(@question.dataset_generator)
        @question_text  = @question.template_text.gsub(/\[\s*D\s*\]/, @dataset.join(", "))
        @solution       = compute_dataset_answer(@dataset, @question.answer_strategy)
      when "definition"
        @question_text  = @question.template_text
        @solution       = @question.answer
      end

      if @question.type&.type_name == "Multiple choice"
        @question_text = @question.template_text
        @answer_choices = @question.answer_choices.to_a.shuffle.map do |choice|
          { id: choice.id, text: choice.choice_text, correct: choice.correct }
        end
        @solution = @answer_choices.find { |choice| choice[:correct] }[:text]
      end

      session[:question_text] = @question_text
      session[:solution] = @solution
    else
      flash[:alert] = "No questions found with the selected topics and types. Please try again."
    end
  end

  def clear_session_data
    keys = %i[
      submitted_answer solution question_text question_img question_id
      try_another_problem is_correct explanation round_decimals question_kind
      exam_questions test_results practice_test_mode
    ]
    keys.each { |key| session.delete(key) }
  end

  def set_selected_topics_and_types
    @selected_topic_ids = session[:selected_topic_ids] || []
    @selected_type_ids = session[:selected_type_ids] || []
    @selected_topics = Topic.where(topic_id: @selected_topic_ids)
    @selected_types  = Type.where(type_id: @selected_type_ids)
  end

  def set_topics
    @topics = Topic.all
  end

  def set_types
    @types = Type.all
  end

  def ensure_not_admin
    redirect_to admin_path, alert: "Admin not allowed to access practice page" if current_user&.admin?
  end

  def generate_random_values(variables, variable_ranges = nil, variable_decimals = nil)
    values = {}
    variables.each_with_index do |variable, index|
      if variable_ranges && variable_decimals && variable_ranges[index] && variable_decimals[index]
        range = variable_ranges[index]
        decimals = variable_decimals[index]
        min, max = range.map(&:to_f)
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
    return template_text if template_text.nil? || variable_values.empty?

    formatted_text = template_text.dup
    variable_names = variables || variable_values.keys.map(&:to_s)

    variable_names.each_with_index do |var, index|
      value = variable_values[var.to_sym]
      formatted_value = variable_decimals && variable_decimals[index] ? sprintf("%.#{variable_decimals[index]}f", value) : value.to_s
      formatted_text.gsub!(/\[\s*#{var}\s*\]/, formatted_value)
    end

    formatted_text
  end

  def evaluate_equation(equation, values)
    return nil if equation.nil?
    expression = equation.dup
    values.each { |var, val| expression.gsub!(var.to_s, val.to_f.to_s) }
    begin
      result = eval(expression)
      result = nil if result.infinite?
    rescue StandardError, SyntaxError
      result = nil
    end
    result
  end

  def evaluate_multiple_choice(answer_choices, submitted_answer)
    correct_choice = answer_choices.find { |ac| ac[:correct] }
    is_correct = submitted_answer == correct_choice[:text] if correct_choice
    [ correct_choice, is_correct ]
  end

  def generate_dataset(generator)
    return [] if generator.blank?
    range_str, size_str = generator.split(",")
    min, max = range_str.strip.split("-").map(&:to_i)
    size = size_str.strip.match(/size=(\d+)/)[1].to_i
    Array.new(size) { rand(min..max) }
  end

  def compute_dataset_answer(dataset, strategy)
    return nil if dataset.blank?
    case strategy
    when "mean"
      (dataset.sum.to_f / dataset.size).round(2)
    when "median"
      sorted = dataset.sort
      mid = dataset.length / 2
      dataset.length.odd? ? sorted[mid] : ((sorted[mid - 1] + sorted[mid]) / 2.0).round(2)
    when "mode"
      dataset.group_by(&:itself).values.max_by(&:size).first
    when "range"
      dataset.max - dataset.min
    when "standard_deviation"
      m = dataset.sum.to_f / dataset.size
      Math.sqrt(dataset.sum { |x| (x - m)**2 } / dataset.size).round(2)
    when "variance"
      m = dataset.sum.to_f / dataset.size
      (dataset.sum { |x| (x - m)**2 } / dataset.size).round(2)
    else
      nil
    end
  end

  def parse_number(value)
    Integer(value) rescue Float(value) rescue nil
  end
end
