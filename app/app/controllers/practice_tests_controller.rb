class PracticeTestsController < ApplicationController
  before_action :set_topics, :set_types, only: [:practice_test_form, :create]
  before_action :set_selected_topics_and_types, only: [:practice_test_generation, :submit_practice_test]

  def practice_test_form
    # Renders the form where the user selects topics/types.
  end

  def practice_test_generation
    # Find questions matching the selected topics and types
    questions_scope = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids)
    
    if questions_scope.count == 0
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

      {
        question_id:   question.id,
        question_text: formatted_text,
        question_img:  question.img,
        solution:      solution
      }
    end

    # Store exam questions in session to be used when grading
    session[:exam_questions] = @exam_questions
  end

  def submit_practice_test
    submitted_answers = params[:answers] || {}  # Hash with keys = question IDs
    exam_questions = session[:exam_questions] || []
    results = []
    score = 0
  
    exam_questions.each do |q|
      # Convert keys from strings to symbols so you can access them as q[:question_id], etc.
      q = q.symbolize_keys
  
      question_id      = q[:question_id]
      solution         = q[:solution]
      submitted_answer = submitted_answers[question_id.to_s].to_s.strip
  
      # Convert the submitted answer to numeric (integer if possible, otherwise float)
      submitted_value = if submitted_answer.to_i.to_s == submitted_answer
                          submitted_answer.to_i
                        else
                          submitted_answer.to_f
                        end
  
      # Convert the correct solution to numeric (integer if possible, otherwise float)
      solution_value = if solution.to_i.to_s == solution.to_s
                         solution.to_i
                       else
                         solution.to_f
                       end
  
      is_correct = (submitted_value == solution_value)
  
      # Record submission if user is logged in
      if current_user && question_id
        Submission.create!(user_id: current_user.id, question_id: question_id, correct: is_correct)
      end
  
      results << {
        question_id:      question_id,
        question_text:    q[:question_text],
        question_img:     q[:question_img],
        submitted_answer: submitted_answer,
        solution:         solution,
        correct:          is_correct
      }
  
      score += 1 if is_correct
    end
  
    # Store the overall test results in session for display
    session[:test_results] = {
      score: score,
      total: exam_questions.count,
      results: results
    }
  
    # Clean up the exam questions from the session
    session.delete(:exam_questions)
  
    redirect_to practice_test_result_path
  end  

  def result
    # Just read (not delete) so the data persists if the user refreshes
    test_results = session[:test_results] || { score: 0, total: 0, results: [] }

    # Provide defaults if keys are missing
    @score   = test_results[:score]   || 0
    @total   = test_results[:total]   || 0
    @results = test_results[:results] || []
  end

  def create
    # Store selected topics/types in session, then redirect
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
    values
  end

  def format_template_text(template_text, variable_values)
    return nil if template_text.nil?
    return template_text if variable_values.empty?

    formatted_text = template_text.dup
    variable_values.each do |variable, value|
      # For example: \( x \) in the text becomes the random value
      formatted_text.gsub!(/\\\(\s*#{variable}\s*\\\)/, value.to_s)
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

  def set_topics
    @topics = Topic.all
  end

  def set_types
    @types = Type.all
  end
end