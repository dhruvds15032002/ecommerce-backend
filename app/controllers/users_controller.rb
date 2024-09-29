class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  skip_before_action :authenticate_user, only: [:signup, :login]

  def signup
    user = User.new(user_params)
    
    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @user, serializer: UserSerializer
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      user.regenerate_token!
      render json: { token: user.token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def logout
    current_user.invalidate_token! # Invalidate token (log out)
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    
    render json: { error: "User not found" }, status: :not_found if @user.nil?
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization']&.split(' ')&.last)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
