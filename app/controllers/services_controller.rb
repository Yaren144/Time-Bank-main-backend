class ServicesController < ApplicationController
  before_action :authenticate_request, except: [:index, :show]
  before_action :set_service, only: [:show, :update, :destroy]
  before_action :authorize_owner, only: [:update, :destroy]

  def index
    services = Service.active
    services = services.by_category(params[:category]) if params[:category].present?
    services = services.where("title LIKE ?", "%#{params[:search]}%") if params[:search].present?
    render json: services.includes(:user).map { |s| serialize(s) }, status: :ok
  end

  def show
    render json: serialize(@service), status: :ok
  end

  def create
    service = @current_user.services.new(service_params)
    service.status = "active"
    if service.save
      render json: serialize(service), status: :created
    else
      render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      render json: serialize(@service), status: :ok
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    render json: { message: "Service deleted" }, status: :ok
  end

  private

  def set_service
    @service = Service.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Service not found" }, status: :not_found
  end

  def authorize_owner
    unless @service.user_id == @current_user.id || @current_user.role == "admin"
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  def service_params
    params.permit(:title, :description, :category, :credits, :status)
  end

  def serialize(s)
    {
      id: s.id,
      title: s.title,
      description: s.description,
      category: s.category,
      credits: s.credits,
      status: s.status,
      owner: {
        id: s.user.id,
        name: "#{s.user.first_name} #{s.user.last_name}"
      },
      created_at: s.created_at
    }
  end
end
