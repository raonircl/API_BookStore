
require 'jwt'
require 'bcrypt'
require_relative '../services/jwt_service'

class UsersController < ApplicationController
  def create
    user_params = params.require(:user).permit(:name, :email, :password)

    if user_params[:password].length < 8
      render_errors('Password must be at least 8 characters long')
      return
    end

    @user = User.new(user_params)
    @user.password = BCrypt::Password.create(params[:password])

    if @user.save
      render_success('User created successfully!')
    else
      render_errors(@user.errors.full_messages)
    end
  end

  def login
    user_params = params.require(:user).permit(:email, :password)

    @user = User.find_by(email: user_params[:email])

    if @user && @user.authenticate(user_params[:password])
      token = JwtService.encode(user_id: @user.id)
      render_success_token('Login sucessful', token)
    else
      render_unauthorized('Invalid email or password')
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def render_success_token(message, token)
    render json: { message: message, token: token }, status: :ok
  end

  def render_unauthorized(errors)
    render json: { errors: errors }, status: :unauthorized
  end
end
