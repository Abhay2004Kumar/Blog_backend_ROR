class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def record_not_found
    render json: { error: "Post not found" }, status: :not_found
  end
end
