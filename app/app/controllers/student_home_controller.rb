class StudentHomeController < ApplicationController
  def index
    @current_user = current_user
    @profile_path = user_path(@current_user)
    @logout_path = logout_path
  end
end
