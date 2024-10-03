# app/exceptions/custom_exception.rb
module CustomException
  class CustomError < StandardError
    attr_reader :status

    def initialize(status, message)
      @status = status
      super(message)
    end
  end
end
