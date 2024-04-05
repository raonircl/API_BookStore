class User < ApplicationRecord
  validates :username, presence: true, format: { with: /\A[a-zA-Z0-9_-]+\z/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }
end
