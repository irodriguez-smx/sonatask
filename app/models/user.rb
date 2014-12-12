class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_many :tasks
  def self.authenticate(username, password)
    return nil if username.nil? || password.nil?
    user = User.find_for_authentication(:email => username)
    return nil  if user.nil?
    user.valid_password?(password) ? user : nil
  end
  
end
