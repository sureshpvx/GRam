class OmniauthCallbacksController < ApplicationController
  skip_before_action :require_authentication

  def google_oauth2
    auth = request.env["omniauth.auth"]
    
    # Debug logging
    Rails.logger.info "========== GOOGLE OAUTH DEBUG =========="
    Rails.logger.info "Raw auth data: #{auth.to_json}"
    Rails.logger.info "Auth provider: #{auth.provider}"
    Rails.logger.info "Auth UID: #{auth.uid}"
    Rails.logger.info "Auth info email: #{auth.info.email}"
    Rails.logger.info "Auth info name: #{auth.info.name}"
    Rails.logger.info "Auth info image: #{auth.info.image}"
    Rails.logger.info "======================================="
    
    user = User.from_omniauth(auth)
    
    # Debug user data after save
    Rails.logger.info "========== USER DEBUG =========="
    Rails.logger.info "User ID: #{user.id}"
    Rails.logger.info "User email: #{user.email_address}"
    Rails.logger.info "User name: #{user.name}"
    Rails.logger.info "User avatar_url: #{user.avatar_url}"
    Rails.logger.info "User provider: #{user.provider}"
    Rails.logger.info "Generated avatar_image: #{user.avatar_image}"
    Rails.logger.info "=============================="
    
    if user.persisted?
      start_new_session_for user
      redirect_to root_path, notice: "Successfully signed in with Google!"
    else
      redirect_to new_session_path, alert: "Failed to sign in with Google."
    end
  end

  def failure
    Rails.logger.error "OAuth failure: #{params.inspect}"
    redirect_to new_session_path, alert: "Authentication failed, please try again."
  end
end 