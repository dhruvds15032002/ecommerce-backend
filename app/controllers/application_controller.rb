class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user

  private

  def authenticate_user
    if request.headers['Authorization'].nil?
      render json: { error: 'Missing Authorization header' }, status: :unauthorized
    else
      token = request.headers['Authorization']&.split(' ')&.last
      @current_user = User.find_by(token: token)
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end
  end
end
