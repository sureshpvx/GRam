class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def self.from_omniauth(auth)
    Rails.logger.info "==== Processing OAuth data ===="
    Rails.logger.info "Auth info: #{auth.info.inspect}"
    
    user = where(email_address: auth.info.email).first_or_initialize
    
    # Always update these fields from Google
    user.email_address = auth.info.email
    user.name = auth.info.name
    # Store the complete Google image URL
    user.avatar_url = auth.info.image if auth.info.image.present?
    user.provider = auth.provider
    user.uid = auth.uid
    
    # Only set password for new users
    user.password = SecureRandom.hex(16) if user.new_record?
    
    Rails.logger.info "User before save: #{user.attributes}"
    user.save!
    Rails.logger.info "User after save: #{user.attributes}"
    Rails.logger.info "============================"
    
    user
  end

  def google_user?
    provider == 'google_oauth2'
  end

  def avatar_image
    if google_user? && avatar_url.present?
      # For Google images, ensure we get a large size
      base_url = avatar_url.split('=').first
      "#{base_url}=s200-c"
    elsif avatar_url.present?
      avatar_url
    elsif name.present?
      "https://ui-avatars.com/api/?name=#{ERB::Util.url_encode(name)}&background=random&color=fff&size=200"
    else
      "https://ui-avatars.com/api/?name=#{ERB::Util.url_encode(email_address.split('@').first)}&background=random&color=fff&size=200"
    end
  end
end
