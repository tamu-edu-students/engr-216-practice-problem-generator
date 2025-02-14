class AdminController < ApplicationController

  def index
    @admin = current_user
    @logout_path = logout_path
    @profile_path = user_path(@admin)
    @admin_roles_path = admin_roles_path
    @student_home_path = student_home_path
    @instructor_home_path = instructor_home_path
  end
end
