module UserAuth
  extend ActiveSupport::Concern

  included do
    before_action :auth_user
  end

  protected

  def auth_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find_by_username(decoded[:username])
    rescue ActiveRecord::RecordNotFound => e
      json_response({message: 'User Not found!'}, 401, e.message)
    rescue JWT::DecodeError => e
      json_response({message: 'Token not valid.'}, 401, 'Sorry! Invalid token')
    end
  end

end