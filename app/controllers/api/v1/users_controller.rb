class Api::V1::UsersController < ApplicationController

  def create
    @user = User.new(user_params)
    if @user.save
      json_response({user: @user.as_json(except: [:password_digest])}, 201, "registration success!")
    else
      resource_validation_error(@user)
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :name)
  end
end
