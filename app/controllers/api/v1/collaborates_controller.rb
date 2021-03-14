class Api::V1::CollaboratesController < ApplicationController

  def show
    @invitation = Invitation.find_by_token(params[:id])
    if @invitation.blank?
      json_response({}, 401, "Sorry! Not a valid invitation code")
    else
      @user = @invitation.user
      @favourites = @user.favourites
                        .joins([{:favourite_items => [:restaurant]}, :user])
                        .includes([{:favourite_items => [:restaurant]}, :user])

      json_response(@favourites.as_json(include: [{favourite_items: {include: :restaurant}}, :user]))
    end
  end

end
