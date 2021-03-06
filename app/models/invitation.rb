class Invitation < ApplicationRecord

  belongs_to :user

  before_create :generate_token
  after_create :deliver_invitation_email

  validates :email, :presence => true, format: {with: URI::MailTo::EMAIL_REGEXP}

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64.to_s if self.token.blank?
  end

  def deliver_invitation_email
    InviteFriendsMailer.invite_friends_to_collaborate(self).deliver
  end

end
