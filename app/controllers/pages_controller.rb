class PagesController < ApplicationController
  before_action { flash.clear }
  skip_before_action :verify_authenticity_token

  def confirm_email;end

  def waiting_for_moderator;end

  def avatar
    user = User.find_by!(email: request.body.read)
    render json: { user: user.email, avatar_url: SecureRandom.uuid }
  end
end
