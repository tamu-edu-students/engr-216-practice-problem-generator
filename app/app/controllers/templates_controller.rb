require 'dentaku'

class TemplatesController < ApplicationController
    before_action :ensure_instructor
    before_action :set_topics_and_types

    def new_equation
      # renders views/templates/new_equation.html.erb
      #build_mc_choices if mc_type_selected?
      default_topic = @topics.first&.id
      @free_resp_id = Type.find_by(type_name: "Free response")&.id
      @mc_id = Type.find_by(type_name: "Multiple choice")&.id
      @question = Question.new(question_kind: "equation", topic_id: default_topic)
      build_mc_choices
    end

    def new_dataset
      # renders views/templates/new_dataset.html.erb
      default_topic = @topics.first&.id
      @free_resp_id = Type.find_by(type_name: "Free response")&.id
      @question = Question.new(question_kind: "dataset", topic_id: default_topic)
    end

    def new_definition
      # renders views/templates/new_definition.html.erb
      default_topic = @topics.first&.id
      @free_resp_id = Type.find_by(type_name: "Free response")&.id
      @mc_id = Type.find_by(type_name: "Multiple choice")&.id
      @question = Question.new(question_kind: "definition", topic_id: default_topic)
      build_mc_choices
    end

    def create_equation
        raw_eq = question_params[:equation].to_s
        # Only convert sqrt to Dentaku-compatible exponent notation
        equation = raw_eq.gsub(/sqrt\(([^)]+)\)/, '(\1) ^ 0.5')

        if mc_type_selected?
          attrs = question_params.except(:variables, :variable_ranges, :variable_decimals)
        else
          vars_param   = question_params[:variables]           || []
          ranges_param = question_params[:variable_ranges]     || []
          decs_param   = question_params[:variable_decimals]   || []

          variables = Array(vars_param)
          variable_ranges = Array(ranges_param).map do |h|
            [ h["min"].to_f, h["max"].to_f ]
          end
          variable_decimals   = Array(decs_param).map(&:to_i)

          begin
            dummy_values = variables.index_with { 1.0 }
            Dentaku::Calculator.new.evaluate!(equation, dummy_values)
          rescue => e
            flash[:alert] = "Invalid equation: #{e.message}"
            redirect_to custom_template_equation_path and return
          end

          

          attrs = question_params.except(:answer_choices_attributes, :variables, :variable_ranges, :variable_decimals)
                                  .merge(
                                    variables: variables,
                                    variable_ranges: variable_ranges,
                                    variable_decimals: variable_decimals
                                  )
        end


        @question = Question.new(
          attrs.merge(
            topic_id: question_params[:topic_id],
            type_id: question_params[:type_id],
            template_text: question_params[:template_text],
            explanation: question_params[:explanation],
            equation: equation,
            question_kind: "equation"
          )
        )


        if @question.save
          redirect_to instructor_home_path, notice: "Equation-based question template created!"
        else
          flash.now[:alert] = @question.errors.full_messages.to_sentence
          build_mc_choices
          render :new_equation
        end
      end

      def create_dataset
        
        if question_params[:dataset_min].present? && question_params[:dataset_max].present? && question_params[:dataset_size].present?
          generator = "#{question_params[:dataset_min].to_i}-#{question_params[:dataset_max].to_i}, size=#{question_params[:dataset_size].to_i}"
        else
          generator = question_params[:dataset_generator].to_s
        end
          
        if generator.blank? || question_params[:answer_strategy].blank?
          flash[:alert] = "Dataset generator and answer type are required."
          return redirect_to custom_template_dataset_path
        end

        @question = Question.new(
          topic_id:          question_params[:topic_id],
          type_id:           question_params[:type_id],
          template_text:     question_params[:template_text],
          dataset_generator: generator,
          answer_strategy:   question_params[:answer_strategy],
          explanation:       question_params[:explanation],
          round_decimals:    question_params[:round_decimals],
          question_kind:     "dataset"
        )

        if @question.save
          redirect_to instructor_home_path, notice: "Dataset-based question template created!"
        else
          flash.now[:alert] = @question.errors.full_messages.to_sentence
          render :new_dataset
        end
      end

      def create_definition
        if mc_type_selected?
          attrs = question_params.except(:answer)
        else
          attrs = question_params
        end

        @question = Question.new(
          attrs.merge(
            topic_id: question_params[:topic_id],
            type_id: question_params[:type_id],
            template_text: question_params[:template_text],
            answer: question_params[:answer],
            explanation: question_params[:explanation],
            question_kind: "definition"
          )
        )
        
        if @question.save
          redirect_to instructor_home_path, notice: "Definition-based question template created!"
        else
          flash.now[:alert] = @question.errors.full_messages.to_sentence
          build_mc_choices
          render :new_definition
        end
      end


    private

    def build_mc_choices
      @question ||= Question.new
      (2 - @question.answer_choices.size).times { @question.answer_choices.build }
    end

    def mc_type_selected?
      question_params[:type_id].to_i == Type.find_by(type_name: "Multiple choice")&.id
    end

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
        :dataset_min,
        :dataset_max,
        :dataset_size,
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
