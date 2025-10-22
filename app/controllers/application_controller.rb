class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  before_action :set_current_user
  
  private
  
  def authenticate_user!
    unless current_user
      redirect_to root_path, alert: 'Please sign in to continue.'
    end
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def set_current_user
    @current_user = current_user
  end
  
  def signed_in?
    current_user.present?
  end
  
  def sign_out
    session[:user_id] = nil
    @current_user = nil
  end
  
  helper_method :current_user, :signed_in?
end
