class PagesController < ApplicationController
  skip_before_action :require_authentication, only: [:home]
  def home
    redirect_to posts_path if authenticated?
  end
end
