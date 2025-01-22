class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:omniauth, :logout]

  # GET /logout
  def logout
    reset_session
    redirect_to welcome_path, notice: 'You are logged out.'
  end


  # GET /auth/google_oauth2/callback
  def omniauth
    auth = request.env['omniauth.auth']
    Rails.logger.debug "Auth object: #{auth.inspect}"
  
    if auth['uid'].present? && auth['provider'].present?
      @user = User.find_or_initialize_by(uid: auth['uid'], provider: auth['provider'])

      email_provider = auth['info']['email'].split('@')[1]
      if email_provider != 'tamu.edu'
        redirect_to welcome_path, alert: 'Please login with an @tamu email'
        return
      end
  
      if @user.new_record?
        @user.email = auth['info']['email']
        names = auth['info']['name'].split
        @user.first_name = names[0]
        @user.last_name = names[1..].join(' ')
        @user.role = 0
        @user.correct_submissions = 0
        @user.total_submissions = 0
      end
  
      if @user.save
        session[:user_id] = @user.id
        redirect_to student_home_path, notice: 'You are logged in.'
      else
        redirect_to welcome_path, alert: 'Error saving user.'
      end
    else
      redirect_to welcome_path, alert: 'Authentication failed: Missing UID or provider.'
    end
  end
  
end
