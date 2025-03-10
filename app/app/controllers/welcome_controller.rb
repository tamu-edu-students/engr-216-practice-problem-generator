class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [ :index ]

  def index
    if logged_in?
      redirect_to student_home_path, notice: "Welcome back!"
    end
  end
end
