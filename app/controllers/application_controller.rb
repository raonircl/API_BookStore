class ApplicationController < ActionController::API
  private

  def render_success(message)
    render json: { message: message }, status: :ok
  end

  def render_errors(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end
end
