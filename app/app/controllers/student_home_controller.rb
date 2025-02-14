class StudentHomeController < ApplicationController
  def index
    @current_user = current_user
    @profile_path = user_path(@current_user)
    @logout_path = logout_path
    @problem_path = problem_form_path
    @progress_path = user_progress_path(@current_user)
    @practice_test_path = practice_test_form_path
  end
end
