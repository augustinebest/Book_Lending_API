class AuthenticationController < ApplicationController
  def signup
    user = User.find_by(email: params[:email])

    if user
      render json: { error: "Email already exists!" }, status: :unprocessable_entity
      return
    end

    user = User.new(user_params)
    if user.save
      token = encode_token({ user_id: user.id })
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    puts "This is a User: #{user.inspect}"

    if user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end

    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      render json: { token: token, message: "Login Successfully!" }, status: :ok
    else
      render json: { error: "Invalid credentials!" }, status: :unauthorized
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def user_params
    puts "Parameters received in request: #{params.inspect}"
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  rescue ActionController::ParameterMissing => e
    puts "ParameterMissing Error: #{e.message}"
    nil
    puts "User***555"
  end
end
