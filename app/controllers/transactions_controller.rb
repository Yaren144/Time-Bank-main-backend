class TransactionsController < ApplicationController
  before_action :authenticate_request

  def index
    sent     = Transaction.where(sender_id: @current_user.id)
    received = Transaction.where(receiver_id: @current_user.id)
    render json: {
      sent:     sent.map     { |t| serialize(t) },
      received: received.map { |t| serialize(t) }
    }, status: :ok
  end

  private

  def serialize(t)
    {
      id: t.id,
      amount: t.amount,
      type: t.transaction_type,
      description: t.description,
      sender_id: t.sender_id,
      receiver_id: t.receiver_id,
      created_at: t.created_at
    }
  end
end
