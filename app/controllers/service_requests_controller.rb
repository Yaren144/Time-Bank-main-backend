class ServiceRequestsController < ApplicationController
  before_action :authenticate_request

  def create
    service = Service.find(params[:service_id])

    if service.user_id == @current_user.id
      render json: { error: "You cannot request your own service" }, status: :unprocessable_entity and return
    end

    if @current_user.time_credits < service.credits
      render json: { error: "Insufficient time credits" }, status: :unprocessable_entity and return
    end

    request = ServiceRequest.new(
      service: service,
      requester: @current_user,
      message: params[:message],
      status: "pending"
    )

    if request.save
      render json: serialize(request), status: :created
    else
      render json: { errors: request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def my_requests
    sent     = ServiceRequest.where(requester_id: @current_user.id).includes(:service)
    received = ServiceRequest.joins(:service).where(services: { user_id: @current_user.id }).includes(:service)
    render json: {
      sent:     sent.map     { |r| serialize(r) },
      received: received.map { |r| serialize(r) }
    }, status: :ok
  end

  def accept
    req = ServiceRequest.find(params[:id])
    return render json: { error: "Not authorized" }, status: :forbidden unless req.service.user_id == @current_user.id
    return render json: { error: "Cannot accept" }, status: :unprocessable_entity unless req.status == "pending"
    req.update(status: "accepted")
    render json: serialize(req), status: :ok
  end

  def reject
    req = ServiceRequest.find(params[:id])
    return render json: { error: "Not authorized" }, status: :forbidden unless req.service.user_id == @current_user.id
    return render json: { error: "Cannot reject" }, status: :unprocessable_entity unless req.status == "pending"
    req.update(status: "rejected")
    render json: serialize(req), status: :ok
  end

  def cancel
    req = ServiceRequest.find(params[:id])
    return render json: { error: "Not authorized" }, status: :forbidden unless req.requester_id == @current_user.id
    return render json: { error: "Cannot cancel" }, status: :unprocessable_entity unless %w[pending accepted].include?(req.status)
    req.update(status: "cancelled")
    render json: serialize(req), status: :ok
  end

def complete
  req = ServiceRequest.find(params[:id])
  return render json: { error: "Not authorized" }, status: :forbidden unless req.service.user_id == @current_user.id
  return render json: { error: "Cannot complete" }, status: :unprocessable_entity unless req.status == "accepted"

  ActiveRecord::Base.transaction do
    req.requester.decrement!(:time_credits, req.service.credits)
    req.service.user.increment!(:time_credits, req.service.credits)
    req.update!(status: "completed")

    Transaction.create!(
      sender: req.requester,
      receiver: req.service.user,
      amount: req.service.credits,
      transaction_type: "service_payment",
      description: "Payment for: #{req.service.title}"
    )
  end

  render json: { message: "Service completed", request: serialize(req) }, status: :ok
end

  private

  def serialize(r)
    {
      id: r.id,
      status: r.status,
      message: r.message,
      service: { id: r.service.id, title: r.service.title, credits: r.service.credits },
      requester_id: r.requester_id,
      created_at: r.created_at
    }
  end
end
