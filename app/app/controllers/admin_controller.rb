class AdminController < ApplicationController

  def index
    @admin = current_user
    @logout_path = logout_path
    @profile_path = user_path(@admin)
  end
end
