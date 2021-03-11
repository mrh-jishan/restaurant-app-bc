class Api::V1::AuthController < ApplicationController

  def create
    @user = User.find_by_username(auth_params[:username].downcase)
    if @user&.authenticate(auth_params[:password])
      token = JsonWebToken.encode(username: @user.username)
      json_response({user: @user.as_json(except: [:password_digest]), token: token}, 201, "login success!")
    else
      json_response({}, 401, "Username & password didn't match!")
    end
  end

  private
  def auth_params
    params.require(:auth).permit(:username, :password)
  end

end
