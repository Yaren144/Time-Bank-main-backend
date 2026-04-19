class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, inclusion: { in: %w[user admin] }

  before_create :set_default_role
  before_create :set_default_credits

  has_many :services, dependent: :destroy
  has_many :service_requests, foreign_key: :requester_id
  has_many :sent_transactions,     class_name: "Transaction", foreign_key: :sender_id
  has_many :received_transactions, class_name: "Transaction", foreign_key: :receiver_id

  private

  def set_default_role
    self.role ||= "user"
  end

  def set_default_credits
    self.time_credits ||= 0
  end
end
