class CreditsController < ApplicationController
  # skip_before_action :verify_authenticity_token  # BU SATIRI TAMAMEN KALDIRIN veya yorum satırı yapın
  before_action :authenticate_api_token

  def add
    user = User.find_by(email: params[:email])
    if user
      user.update(time_credits: user.time_credits + params[:amount].to_i)
      render json: { success: true, new_balance: user.time_credits }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def authenticate_api_token
    token = request.headers["Authorization"]&.split(" ")&.last
    expected_token = ENV["MAIN_BACKEND_API_TOKEN"]
    unless token && expected_token && ActiveSupport::SecurityUtils.secure_compare(token, expected_token)
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
