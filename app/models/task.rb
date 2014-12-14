class Task < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  include PgSearch
  pg_search_scope :search_by_description, :against => [:description,:tags]
  belongs_to :user
  before_save :default_values
  scope :default_order, order("position")
  def default_values
    self.status ||= 0
  end
end
