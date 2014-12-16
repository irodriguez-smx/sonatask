class User < ActiveRecord::Base
  acts_as_token_authenticatable

  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :validatable
  )

  has_many :tasks

  def self.authenticate(username, password)
    # this is smelly
    return nil unless username && password
    user = User.find_for_authentication(:email => username)
    return nil unless user
    user.valid_password?(password) ? user : nil
  end

end
