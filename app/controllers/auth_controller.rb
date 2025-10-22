class AuthController < ApplicationController
  skip_before_action :authenticate_user!
  
  def passthru
    # Redirect to the OAuth provider
    provider = params[:provider]
    case provider
    when 'google_oauth2'
      redirect_to "https://accounts.google.com/oauth/authorize?client_id=#{ENV['GOOGLE_CLIENT_ID']}&redirect_uri=#{CGI.escape(request.base_url + '/auth/google_oauth2/callback')}&scope=email%20profile&response_type=code&access_type=offline&prompt=select_account", allow_other_host: true
    when 'github'
      redirect_to "https://github.com/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT_ID']}&redirect_uri=#{CGI.escape(request.base_url + '/auth/github/callback')}&scope=user:email", allow_other_host: true
    else
      redirect_to root_path, alert: 'Unsupported authentication provider.'
    end
  end
  
  def callback
    auth = request.env['omniauth.auth']
    
    if auth.present?
      user = User.from_omniauth(auth)
      
      if user.persisted?
        # Log the login attempt
        UserLogin.create!(
          user: user,
          ip_address: request.remote_ip,
          user_agent: request.user_agent,
          signed_in_at: Time.current
        )
        
        # Download and attach profile photo if available
        if auth.info.image.present? && !user.photo.attached?
          download_and_attach_photo(user, auth.info.image)
        end
        
        session[:user_id] = user.id
        redirect_to dashboard_path, notice: 'Successfully signed in!'
      else
        redirect_to root_path, alert: 'Failed to create user account.'
      end
    else
      redirect_to root_path, alert: 'Authentication failed.'
    end
  end

  def failure
    redirect_to root_path, alert: 'Authentication failed. Please try again.'
  end

  private

  def download_and_attach_photo(user, image_url)
    require 'open-uri'
    require 'mini_magick'
    
    begin
      # Download the image
      downloaded_image = URI.open(image_url)
      
      # Process with MiniMagick to resize if needed
      image = MiniMagick::Image.open(downloaded_image)
      
      # Resize to 300x300 if larger
      if image.width > 300 || image.height > 300
        image.resize '300x300>'
      end
      
      # Attach to user
      user.photo.attach(
        io: StringIO.new(image.to_blob),
        filename: "profile_#{user.id}.jpg",
        content_type: 'image/jpeg'
      )
    rescue => e
      Rails.logger.error "Failed to download profile photo: #{e.message}"
    end
  end
end
