class User < ApplicationRecord
  validates :name, presence: true, format: { without: /\d/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }
end
