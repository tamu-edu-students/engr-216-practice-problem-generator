class StudentHomeController < ApplicationController
  def index
    @current_user = current_user
    @profile_path = user_path(@current_user)
    @logout_path = logout_path
    @problem_path = practice_form_path
    @practice_test_path = practice_form_path
    @progress_path = user_progress_path(@current_user)
    @leaderboard_path = leaderboard_path

    @total_submissions = @current_user.total_submissions
    @correct_submissions = @current_user.correct_submissions
    @accuracy = @current_user.total_accuracy

    @submissions_by_topic = @current_user.submissions_by_topic
    @topic_names = @submissions_by_topic.keys
  end
end
