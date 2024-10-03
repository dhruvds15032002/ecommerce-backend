class ApplicationController < ActionController::Base
  include ExceptionHandler
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user

  rescue_from StandardError, with: :handle_internal_server_error
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

  def handle_internal_server_error(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))

    render json: { error: 'Something went wrong, please try again later.' }, status: :internal_server_error
  end
end
