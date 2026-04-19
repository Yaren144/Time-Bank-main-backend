class ServiceRequest < ApplicationRecord
  belongs_to :service
  belongs_to :requester, class_name: "User"

  validates :status, inclusion: { in: %w[pending accepted rejected cancelled completed] }

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= "pending"
  end
end
