class Review < ApplicationRecord
  belongs_to :service_request
  belongs_to :reviewer, class_name: "User"

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :service_request_id, uniqueness: { message: "already reviewed" }

  validate :only_completed_requests

  private

  def only_completed_requests
    unless service_request&.status == "completed"
      errors.add(:base, "Can only review completed services")
    end
  end
end
