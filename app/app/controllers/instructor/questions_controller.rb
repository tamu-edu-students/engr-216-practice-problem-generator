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
      if @question.update(question_params)
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
        :variables,
        :variable_ranges,
        :variable_decimals,
        :explanation
      )
    end


    def set_types_and_topics
      @types = Type.all
      @topics = Topic.all
    end
  end
end
