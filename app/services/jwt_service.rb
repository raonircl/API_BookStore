
require 'jwt'
require 'dotenv'

class JwtService
  def self.encode(user_id)
    payload = { user_id: user_id }
    secret = ENV['SECRET_KEY_BASE']
    JWT.encode(payload, secret, 'HS256')
  end
end
