class Api::V1::InvitationsController < SecureController

  def create
    @invitation = @current_user.invitations.new({:email => params[:email]})
    if @invitation.save
      json_response(@invitation, 201, "invitation send successfully!")
    else
      resource_validation_error(@invitation)
    end
  end

  def index
    @invitations = @current_user.invitations.all
    json_response(@invitations)
  end

  def show
    @invitation = @current_user.invitations.find_by_id(params[:id])
    if @invitation.blank?
      json_response({}, 401, "Sorry! Not a valid invitation id")
    else
      @user = @invitation.user
      @favourites = @user.favourites
                        .joins([{:favourite_items => [:restaurant]}, :user])
                        .includes([{:favourite_items => [:restaurant]}, :user])

      json_response(@favourites.as_json(include: [{favourite_items: {include: :restaurant}}, :user]))
    end
  end

end
