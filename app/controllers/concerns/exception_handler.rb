# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
  extend ActiveSupport::Concern

  # Custom error class for handling exceptions
  class CustomError < StandardError; end

  # Method to raise a 422 error with a message
  def throw_error(message)
    raise CustomError.new(message) # Raise a custom error with the provided message
  end

  # Rescue from the custom error globally
  included do
    rescue_from CustomError do |error|
      render json: { error: error.message }, status: :unprocessable_entity # 422 error
    end
  end
end
