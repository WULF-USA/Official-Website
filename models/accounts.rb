require 'bcrypt'

class Account < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt
  
  validates :username,
    format: { with: /\A[\w]+\Z/ },
    length: { in: 2..15 },
    uniqueness: true,
    presence: true
  validates :is_super,
    inclusion: { in: [true, false] },
    presence: true
  
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end