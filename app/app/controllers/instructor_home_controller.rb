class InstructorHomeController < ApplicationController
  def index
    @instructor = current_user
    @logout_path = logout_path
    @profile_path = user_path(@instructor)
  end
end
