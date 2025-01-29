class InstructorHomeController < ApplicationController
  before_action :ensure_instructor # Ensure the user is an instructor

  def index
    @instructor = current_user
    @logout_path = logout_path
  end

  private

  def ensure_instructor
    unless current_user&.instructor?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
