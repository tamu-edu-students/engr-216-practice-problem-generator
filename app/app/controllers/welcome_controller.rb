class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [ :index ]

  def index
    if logged_in?
      flash.keep
      flash[:notice] ||= "Welcome back!"
      redirect_to student_home_path
    end
  end
end
