class AdminRolesController < ApplicationController
  before_action :ensure_admin

  def index
    @users = User.all
    @roles = User.roles.keys
    @admin_roles_path = admin_roles_path
  end

  def update_role
    user = User.find_by!(id: params[:id])  # Raises RecordNotFound if user doesn't exist

    if user.update(role: params[:role])
      flash[:notice] = "User role updated successfully."
    end
    redirect_to admin_roles_path
  end

  def ensure_admin
    unless current_user&.admin?
      flash[:alert] = "You do not have permission to access this page."
      redirect_to root_path
    end
  end
end
