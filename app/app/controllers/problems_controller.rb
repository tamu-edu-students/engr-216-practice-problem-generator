class ProblemsController < ApplicationController
    before_action :set_topics, :set_types, only: [ :problem_form, :create ]
    before_action :set_selected_topics_and_types, only: [ :problem_generation, :submit_answer ]


    def problem_form
    end

    def problem_generation
      @question = Question.where(topic_id: @selected_topic_ids, type_id: @selected_type_ids).order("RANDOM()").first

      if @question.present?
        @variable_values = generate_random_values(@question.variables)
        @question_text = format_template_text(@question.template_text, @variable_values) if @question.template_text.present?
        @solution = evaluate_equation(@question.equation, @variable_values) || @question.answer

        session[:solution] = @solution
        session[:question_text] = @question_text
        session[:question_img] = @question_img

      else
        flash[:alert] = "No questions found with the selected topics and types. Please try again."
      end
    end

    def submit_answer
      @submitted_answer = params[:answer].to_s.strip
      @solution = session[:solution]
      @question_text = session[:question_text]
      @question_img = session[:question_img]

      is_correct = @submitted_answer == @solution.to_s.strip

      redirect_to problem_result_path(
        correct: is_correct,
        submitted_answer: @submitted_answer,
        solution: @solution,
        question_text: @question_text,
        question_img: @question_img
      )
    end

    def result
      @correct = params[:correct] == "true"
      @submitted_answer = params[:submitted_answer]
      @solution = params[:solution]
      @question_text = params[:question_text]
      @question_img = params[:question_img]
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
