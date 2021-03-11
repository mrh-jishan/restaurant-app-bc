class SecureController < ApplicationController
  include UserAuth

  def index
    json_response(@current_user.profile)
  end
end
