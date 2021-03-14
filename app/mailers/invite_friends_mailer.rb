class InviteFriendsMailer < ApplicationMailer
  default from: "robiul.hassan12102@gmail.com"

  def invite_friends_to_collaborate(invitation)
    @invitation = invitation
    mail(:to => @invitation.email, :subject => "Invite to collaborate (add, remove, edit name) on the collections !")
  end

end
