class ApplicationController < ActionController::API
  # Encode the JWT with a secret key
  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    if auth_header
      token = auth_header.split(" ")[1]
      begin
        JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
      rescue JWT::DecodeError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end
  end

  def current_user
    decoded_token = decode_token
    if decode_token
      user_id = decoded_token[0]["user_id"]
      @current_user = User.find_by(id: user_id)
    end
  end

  def authorize_request
    render json: { error: "Please Log in" }, status: :unauthorized unless current_user
  end
end
