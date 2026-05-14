class ReviewsController < ApplicationController
  before_action :authenticate_request, only: [:create]

  def create
    req = ServiceRequest.find(params[:service_request_id])

    unless req.requester_id == @current_user.id
      render json: { error: "Not authorized" }, status: :forbidden and return
    end

    review = Review.new(
      service_request: req,
      reviewer: @current_user,
      rating: params[:rating],
      comment: params[:comment]
    )

    if review.save
      render json: serialize(review), status: :created
    else
      render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    reviews = Review.includes(:reviewer, :service_request)
    render json: reviews.map { |r| serialize(r) }, status: :ok
  end

  private

  def serialize(r)
    {
      id: r.id,
      rating: r.rating,
      comment: r.comment,
      reviewer: r.reviewer.first_name + " " + r.reviewer.last_name,
      service_request_id: r.service_request_id,
      service_id: r.service_request.service_id,
      created_at: r.created_at
    }
  end
end
