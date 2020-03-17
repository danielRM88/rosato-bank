class UserTokensController < ApplicationController
  def create
    user = User.find_by(email: params[:email].to_s.downcase)

    if user && user.authenticate(params[:password])
      auth_token = JsonWebToken.encode({user_id: user.id})
      render json: {auth_token: auth_token}, status: :ok
    else
      render json: {error: 'Invalid username / password'}, status: :unauthorized
    end
  end
end
