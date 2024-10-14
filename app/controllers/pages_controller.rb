class PagesController < ApplicationController
  before_action { flash.clear }
  skip_before_action :verify_authenticity_token

  def confirm_email;end

  def waiting_for_moderator;end

  def avatar
    # sleep rand(1)
    render json: { user: request.body.read, avatar_url: SecureRandom.uuid }
  end
end
