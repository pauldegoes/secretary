class ProfileController < ApplicationController
  def show
    @user = current_user
    @login_history = @user.user_logins.recent.limit(10)
  end

  def update
    @user = current_user
    
    if params[:user] && params[:user][:photo].present?
      @user.photo.attach(params[:user][:photo])
      redirect_to profile_path, notice: 'Profile photo updated successfully!'
    else
      redirect_to profile_path, alert: 'No photo selected.'
    end
  end
end
