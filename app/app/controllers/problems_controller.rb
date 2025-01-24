class ProblemsController < ApplicationController
    before_action :set_topics, :set_types, only: [ :problem_form, :create ]

    def problem_form
    end

    def problem_generation
      selected_topic_ids = session[:selected_topic_ids] || []
      logger.debug "Selected Topic IDs from session: #{selected_topic_ids}"
      @selected_topics = Topic.where(topic_id: selected_topic_ids)

      selected_type_ids = session[:selected_type_ids] || []
      @selected_types = Type.where(type_id: selected_type_ids)

      @question = Question.where(topic_id: selected_topic_ids, type_id: selected_type_ids).order("RANDOM()").first

      if @question.present?
        @variable_values = generate_random_values(@question.variables)

        @question_text = format_template_text(@question.template_text, @variable_values) if @question.template_text.present?

        if @question.equation.present?
          @solution = evaluate_equation(@question.equation, @variable_values) if @question.equation.present?
        else
          @solution = @question.answer
        end
      else
        flash[:alert] = "No questions found with the selected topics and types. Please try again."
      end
    end

    def create
        selected_topic_ids = params[:topic_ids] || []
        session[:selected_topic_ids] = selected_topic_ids

        selected_type_ids = params[:type_ids] || []
        session[:selected_type_ids] = selected_type_ids

        redirect_to problem_generation_path, notice: "Question topics and types saved in session!"
      end

      private

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
          expression.gsub!(variable.to_s, value.to_s)
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
