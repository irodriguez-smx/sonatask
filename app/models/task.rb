class Task < ActiveRecord::Base
  belongs_to :user
  before_save :default_values
  scope :default_order, order("position")
  def default_values
    self.status ||= 0
  end
end
