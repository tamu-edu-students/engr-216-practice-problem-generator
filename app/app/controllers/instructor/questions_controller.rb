module Instructor
  class QuestionsController < ApplicationController
    before_action :set_question, only: [ :edit, :update, :destroy ]
    before_action :set_types_and_topics


    def index
      if params[:question_kind].present?
        @questions = Question.where(question_kind: params[:question_kind])
      else
        @questions = Question.all
      end

      @question_kinds = Question.distinct.where.not(question_kind: nil).pluck(:question_kind)
    end

    def edit
      # @question is set by before_action
    end

    def update
      var_ranges = question_params.delete(:variable_ranges) || []
      var_decimals = question_params.delete(:variable_decimals) || []

      formatted_ranges = var_ranges.map { |h| [ h[:min].to_f, h[:max].to_f ] }
      formatted_decimals = var_decimals.map(&:to_i)

      attrs = question_params.to_h.merge(
        variable_ranges: formatted_ranges,
        variable_decimals: formatted_decimals
      )

      if @question.question_kind == "equation" && !@question.multiple_choice?
        raw_eq = attrs[:equation].to_s
        # Only convert sqrt to Dentaku-compatible exponent notation
        equation = raw_eq.gsub(/sqrt\(([^)]+)\)/, '(\1) ^ 0.5')

        variables = Array(attrs[:variables])

        begin
          dummy_values = variables.index_with { 1.0 }
          Dentaku::Calculator.new.evaluate!(equation, dummy_values)
        rescue => e
          flash[:alert] = "Invalid equation: #{e.message}"
          redirect_to custom_template_equation_path and return
        end

      end

      if @question.update(attrs)
        redirect_to instructor_questions_path, notice: "Question updated successfully!"
      else
        flash.now[:alert] = "There was an error updating the question."
        render :edit
      end
    end

    def destroy
      @question.destroy
      redirect_to instructor_questions_path, notice: "Question deleted successfully."
    end

    private

    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(
        :template_text,
        :question_text,
        :question_kind,
        :topic_id,
        :type_id,
        :equation,
        :explanation,
        :round_decimals,
        variables: [],
        variable_ranges: [ :min, :max ],
        variable_decimals: [],


        answer_choices_attributes: [
          :id,
          :choice_text,
          :correct,
          :_destroy
        ],
      )
    end


    def set_types_and_topics
      @types = Type.all
      @topics = Topic.all
    end
  end
end
