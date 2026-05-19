class AdminController < ApplicationController
  before_action :authenticate_request
  before_action :authorize_admin

  def users
    users = User.all
    render json: users.map { |u| serialize_user(u) }, status: :ok
  end

  def toggle_user
    user = User.find(params[:id])
    user.update(active: !user.active)
    render json: { message: "User updated", user: serialize_user(user) }, status: :ok
  end

def toggle_role
  user = User.find(params[:id])
  new_role = user.role == "admin" ? "user" : "admin"
  user.update(role: new_role)
  render json: { message: "Role updated", user: serialize_user(user) }, status: :ok
end

  def services
    services = Service.includes(:user).all
    render json: services.map { |s| {
      id: s.id, title: s.title, status: s.status,
      credits: s.credits, category: s.category,
      owner: s.user.first_name + " " + s.user.last_name
    }}, status: :ok
  end

  def toggle_service
    service = Service.find(params[:id])
    new_status = service.status == "active" ? "inactive" : "active"
    service.update(status: new_status)
    render json: { message: "Service updated", status: new_status }, status: :ok
  end

  def delete_service
    service = Service.find(params[:id])
    service.destroy
    render json: { message: "Service deleted" }, status: :ok
  end

  def transactions
    transactions = Transaction.includes(:sender, :receiver).all
    render json: transactions.map { |t| {
      id: t.id, amount: t.amount,
      type: t.transaction_type,
      description: t.description,
      sender: t.sender.first_name + " " + t.sender.last_name,
      receiver: t.receiver.first_name + " " + t.receiver.last_name,
      created_at: t.created_at
    }}, status: :ok
  end

  def balances
    users = User.all
    render json: users.map { |u| {
      id: u.id,
      name: u.first_name + " " + u.last_name,
      email: u.email,
      time_credits: u.time_credits,
      active: u.active
    }}, status: :ok
  end

  private

  def authorize_admin
    unless @current_user.role == "admin"
      render json: { error: "Access denied. Admins only." }, status: :forbidden
    end
  end

  def serialize_user(u)
    {
      id: u.id, email: u.email,
      first_name: u.first_name, last_name: u.last_name,
      role: u.role, time_credits: u.time_credits,
      active: u.active, created_at: u.created_at
    }
  end
end
