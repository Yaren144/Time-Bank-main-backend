class Service < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :credits, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[active inactive] }

  has_many :service_requests, dependent: :destroy

  before_create :set_defaults

  scope :active, -> { where(status: "active") }
  scope :by_category, ->(cat) { where(category: cat) }

  private

  def set_defaults
    self.status ||= "active"
  end
end
