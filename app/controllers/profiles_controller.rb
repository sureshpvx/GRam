class ProfilesController < ApplicationController
  def show
    if Current.user.nil?
      redirect_to new_session_path, alert: "Please sign in to view your profile"
      return
    end
    @user = Current.user
  end
end
