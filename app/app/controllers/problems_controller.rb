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
    end

    def create
        selected_topic_ids = params[:topic_ids] || []
        session[:selected_topic_ids] = selected_topic_ids

        selected_type_ids = params[:type_ids] || []
        session[:selected_type_ids] = selected_type_ids

        redirect_to problem_generation_path, notice: "Question topics and types saved in session!"
      end

      private

      def set_topics
        @topics = Topic.all
      end

      def set_types
        @types = Type.all
      end
end
