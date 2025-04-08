class ProblemsController < ApplicationController
  before_action :set_topics, :set_types, only: [:problem_form, :create]
  before_action :set_selected_topics_and_types, only: [:problem_generation, :submit_answer]

  def problem_form
    clear_problem_session_data
  end

  def problem_generation
    # Clear existing session if "Try Another Problem" was triggered
    if session[:try_another_problem]
      %i[
        submitted_answer solution question_text question_img question_id
        try_another_problem is_correct explanation round_decimals question_kind
      ].each { |key| session.delete(key) }
    end
  
    # Reuse existing question if it exists in the session and is still valid
    if session[:question_id].present?
      @question = Question.find_by(id: session[:question_id])
  
      if @question.present?
        # Pull all relevant session data
        @question_text   = session[:question_text]
        @solution        = session[:solution]
        @question_img    = session[:question_img]
        @submitted_answer = session[:submitted_answer]
        @is_correct      = session[:is_correct]
        @explanation     = session[:explanation]
        @round_decimals  = session[:round_decimals]
        @question_kind   = session[:question_kind]
        return
      else
        # Stale session[:question_id], remove and regenerate
        session.delete(:question_id)
      end
    end
  
    # Generate new question
    @question = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids).order("RANDOM()").first
  
    if @question.present?
      session[:question_id]     = @question.id
      session[:question_kind]   = @question.question_kind
      session[:explanation]     = @question.explanation
  

      case @question.question_kind
      when "equation"
        @variable_values = generate_random_values(
          @question.variables,
          @question.variable_ranges,
          @question.variable_decimals
        )
  
        @question_text = format_template_text(
          @question.template_text,
          @variable_values,
          @question.variable_decimals,
          @question.variables
        )
  
        @solution = evaluate_equation(@question.equation, @variable_values)
  
        if @solution.is_a?(Float) && @question.round_decimals.present?
          @solution = @solution.round(@question.round_decimals)
        end
  
        session[:round_decimals] = @question.round_decimals
  
      when "dataset"
        @dataset = generate_dataset(@question.dataset_generator)
  
        @question_text = @question.template_text.gsub("[D]", @dataset.join(", "))
        @solution = compute_dataset_answer(@dataset, @question.answer_strategy)
  
      when "definition"
        @question_text = @question.template_text
        @solution = @question.answer
      end
      
      if @question.type&.type_name == "Multiple choice"
        @question_text = @question.template_text
        @answer_choices = @question.answer_choices.to_a.shuffle.map do |choice|
          {
            id: choice.id,
            text: choice.choice_text,
            correct: choice.correct
          }
        end
        @solution = @answer_choices.find { |choice| choice[:correct] }[:text]
      end
      
      
  
      session[:question_text] = @question_text
      session[:solution] = @solution
    else
      flash[:alert] = "No questions found with the selected topics and types. Please try again."
    end
  end
  

  def submit_answer
    @submitted_answer = params[:answer].to_s.strip
    @solution = session[:solution]
    @question_text = session[:question_text]
    @question_img = session[:question_img]
    question_id = session[:question_id]
    user = current_user
    question_kind = session[:question_kind]
    @question = Question.find_by(id: question_id)
  
    if @question&.type&.type_name == 'Multiple choice'
      selected_choice_id = params[:answer_choice_id].to_i
      selected_choice = @question.answer_choices.find_by(id: selected_choice_id)
      @is_correct = selected_choice&.correct
      @submitted_answer = selected_choice&.choice_text || "[No answer selected]"
      @solution = @question.answer_choices.find_by(correct: true)&.choice_text
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
    
  
    if user && @question
      Submission.create!(user_id: user.id, question_id: @question.id, correct: @is_correct)
    else
      Rails.logger.error "Submission failed: Missing or invalid question."
    end
  
    session[:explanation] = @question&.explanation
    session[:submitted_answer] = @submitted_answer
    session[:is_correct] = @is_correct
  
    redirect_to problem_generation_path
  end
  


  def try_another_problem
    session[:try_another_problem] = true
    redirect_to problem_generation_path
  end

  def create
    session[:selected_topic_ids] = params[:topic_ids] || []
    session[:selected_type_ids] = params[:type_ids] || []
    redirect_to problem_generation_path, notice: "Question topics and types saved in session!"
  end

  private

  def clear_problem_session_data
    keys = %i[submitted_answer solution question_text question_img question_id try_another_problem is_correct explanation round_decimals question_kind]
    keys.each { |key| session.delete(key) }
  end

  def parse_number(value)
    Integer(value) rescue Float(value) rescue nil
  end

  def set_selected_topics_and_types
    @selected_topic_ids = session[:selected_topic_ids] || []
    @selected_topics = Topic.where(topic_id: @selected_topic_ids)
    @selected_type_ids = session[:selected_type_ids] || []
    @selected_types = Type.where(type_id: @selected_type_ids)
  end

  def set_topics
    @topics = Topic.all
  end

  def set_types
    @types = Type.all
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
      Math.sqrt(dataset.sum { |x| (x - m) ** 2 } / dataset.size).round(2)
    when "variance"
      m = dataset.sum.to_f / dataset.size
      (dataset.sum { |x| (x - m) ** 2 } / dataset.size).round(2)
    else
      nil
    end
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
      formatted_text.gsub!(/\[\s*#{var}\s*\]/, formatted_value)
    end

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
      Rails.logger.error "Equation evaluation error: #{e.message}"
      result = nil
    end
    result
  end
end
