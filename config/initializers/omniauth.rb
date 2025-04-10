# Disable the CSRF protection for OmniAuth paths
OmniAuth.config.allowed_request_methods = %i[get]
OmniAuth.config.silence_get_warning = true

# Debug logging for environment variables
Rails.logger.info "=== OmniAuth Configuration ==="
Rails.logger.info "GOOGLE_CLIENT_ID: #{ENV['GOOGLE_CLIENT_ID'].inspect}"
Rails.logger.info "GOOGLE_CLIENT_SECRET: #{ENV['GOOGLE_CLIENT_SECRET'].inspect}"
Rails.logger.info "============================"

# Load environment variables from .env.development if in development
if Rails.env.development?
  require 'dotenv'
  Dotenv.load('.env.development')
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    scope: 'email,profile',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 50,
    provider_ignores_state: true
  }
end

# Add CSRF token verification
Rails.application.config.middleware.use ActionDispatch::Cookies
Rails.application.config.middleware.use ActionDispatch::Session::CookieStore
OmniAuth.config.before_request_phase do |env|
  request = Rack::Request.new(env)
  request.session['omniauth.state'] = SecureRandom.hex(32)
end 