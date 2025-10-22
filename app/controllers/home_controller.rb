class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  
  def index
    redirect_to dashboard_path if signed_in?
  end
end
