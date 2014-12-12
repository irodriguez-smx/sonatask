class Task < ActiveRecord::Base
  belongs_to :user
  before_save :default_values
  def default_values
    self.status ||= 0
  end
end
