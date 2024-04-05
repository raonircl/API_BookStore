class ApplicationController < ActionController::API
  private

  def render_create(message)
    render json: { message: message }, status: :created
  end

  def render_errors(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def render_success_token(message, token)
    render json: { message: message, token: token }, status: :ok
  end

  def render_unauthorized(errors)
    render json: { errors: errors }, status: :unauthorized
  end
end
