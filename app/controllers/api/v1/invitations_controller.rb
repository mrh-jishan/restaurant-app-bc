class Api::V1::InvitationsController < SecureController

  def create
    @invitation = @current_user.invitations.new({:email => params[:email]})
    if @invitation.save
      json_response(@invitation, 201, "registration success!")
    else
      resource_validation_error(@invitation)
    end

  end


  def index
    @invitations = @current_user.invitations.all
    json_response(@invitations)
  end


  def show
    @invitation = @current_user.invitations.find(params[:id])
    json_response(@invitation)
  end

end
