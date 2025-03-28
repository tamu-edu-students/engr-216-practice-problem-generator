class UsersController < ApplicationController
  def show
    @current_user = User.find(params[:id])
  end

  def save_instructor
    begin
      instructor = User.find(params[:instructor_id])
      if current_user.update(instructor_id: instructor.id)
        flash[:notice] = "Instructor saved successfully!"
      end
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Failed to save instructor."
      end

    redirect_back(fallback_location: user_path(current_user.id)) # Redirects back to the same page
  end

  def progress
    @user = current_user
    @total_submissions = @user.total_submissions
    @correct_submissions = @user.correct_submissions
    @accuracy = @user.total_accuracy

    @submissions_by_topic = @user.submissions_by_topic
    @topic_names = @submissions_by_topic.keys
  end

end
