class AdminController < ApplicationController

  def index
    @admin = current_user
    @logout_path = logout_path
    @profile_path = user_path(@admin)
    @admin_roles_path = admin_roles_path
  end
end
