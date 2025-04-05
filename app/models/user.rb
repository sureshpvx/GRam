class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def self.from_omniauth(auth)
    where(email_address: auth.info.email).first_or_initialize do |user|
      user.email_address = auth.info.email
      user.password = SecureRandom.hex(16) # Generate a random password for Google users
      user.save!
    end
  end
end
