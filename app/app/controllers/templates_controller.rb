class TemplatesController < ApplicationController
    before_action :ensure_instructor
    before_action :set_topics_and_types

    def new_equation
      # renders views/templates/new_equation.html.erb
    end

    def new_dataset
      # renders views/templates/new_dataset.html.erb
    end

    def new_definition
      # renders views/templates/new_definition.html.erb
    end

    def create_equation
        raw_eq = params[:equation]
        # Only convert sqrt to Dentaku-compatible exponent notation
        equation = raw_eq.gsub(/sqrt\(([^)]+)\)/, '(\1) ^ 0.5')


        vars_param   = question_params[:variables]           || []
        ranges_param = question_params[:variable_ranges]     || []
        decs_param   = question_params[:variable_decimals]   || []

        variables = Array(vars_param)
        variable_ranges = Array(ranges_param).map do |h|
          [ h["min"].to_f, h["max"].to_f ]
        end
        variable_decimals   = Array(decs_param).map(&:to_i)

        puts "Variables: #{variables.inspect}"
        puts "Variable Ranges: #{variable_ranges.inspect}"
        puts "Variable Decimals: #{variable_decimals.inspect}"
        puts "Equation: #{equation.inspect}"

        begin
          dummy_values = variables.index_with { 1.0 }
          Dentaku::Calculator.new.evaluate!(equation, dummy_values)
        rescue => e
          flash[:alert] = "Invalid equation: #{e.message}"
          redirect_to custom_template_equation_path and return
        end

        @question = Question.new(
          question_params.except(:variables, :variable_ranges, :variable_decimals)
          .merge(
            topic_id: params[:topic_id],
            type_id: params[:type_id],
            template_text: params[:template_text],
            explanation: params[:explanation],
            equation: equation,
            variables: variables,
            variable_ranges: variable_ranges,
            variable_decimals: variable_decimals,
            question_kind: "equation"
          )
        )

        puts "Question: #{@question.inspect}"

        if @question.save
          redirect_to instructor_home_path, notice: "Equation-based question template created!"
        else
          flash.now[:alert] = @question.errors.full_messages.to_sentence
          render :new_equation
        end
      end

      def create_dataset
        if params[:dataset_generator].blank? || params[:answer_strategy].blank?
          flash[:alert] = "Dataset generator and answer type are required."
          redirect_to custom_template_dataset_path and return
        end

        Question.create!(
          topic_id: params[:topic_id],
          type_id: params[:type_id],
          template_text: params[:template_text],
          dataset_generator: params[:dataset_generator],
          answer_strategy: params[:answer_strategy],
          explanation: params[:explanation],
          question_kind: "dataset"
        )

        redirect_to instructor_home_path, notice: "Dataset-based question template created!"
      end

      def create_definition
        if params[:template_text].blank? || params[:answer].blank?
          flash[:alert] = "Both definition and term are required."
          redirect_to custom_template_definition_path and return
        end

        Question.create!(
          topic_id: params[:topic_id],
          type_id: params[:type_id],
          template_text: params[:template_text],  # Definition shown to student
          answer: params[:answer],                # Correct term student must provide
          explanation: params[:explanation],
          question_kind: "definition"
        )

        redirect_to instructor_home_path, notice: "Definition-based question template created!"
      end


    private

    def ensure_instructor
      unless current_user&.instructor? || current_user&.admin?
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end

    def set_topics_and_types
      @topics = Topic.all
      @types = Type.all
    end

    def question_params
      params.require(:question).permit(
        :topic_id,
        :type_id,
        :template_text,
        :equation,
        :dataset_generator,
        :answer_strategy,
        :answer,
        :explanation,
        :round_decimals,
        :question_kind,
        variables: [],
        variable_ranges: [:min, :max],
        variable_decimals: [],
        answer_choices_attributes: [:id, :choice_text, :correct, :_destroy]
      )
    end
end
