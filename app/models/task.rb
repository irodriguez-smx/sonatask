class Task < ActiveRecord::Base
  include PgSearch
  mount_uploader :attachment, AttachmentUploader

  pg_search_scope :search_by_description,       :against => [:description,:tags]

  belongs_to :user

  before_validation :default_values

  validates :description,                                         presence: true
  validates :status,                                              presence: true
  validates :user,                                                presence: true
  validates :expiration,                                          presence: true
  validates :position,                                            presence: true

  scope :default_order,                                        order("position")

  private

  def default_values
    self.status ||= 0
  end
end
