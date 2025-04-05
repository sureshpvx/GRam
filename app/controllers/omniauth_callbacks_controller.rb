class OmniauthCallbacksController < ApplicationController
  skip_before_action :require_authentication

  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      start_new_session_for user
      redirect_to root_path, notice: "Successfully signed in with Google!"
    else
      redirect_to new_session_path, alert: "Failed to sign in with Google."
    end
  end

  def failure
    redirect_to new_session_path, alert: "Authentication failed, please try again."
  end
end 