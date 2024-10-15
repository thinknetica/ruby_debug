# frozen_string_literal: true
require Rails.root.join('lib/api_errors/base')
require Rails.root.join('lib/api_errors/message_handler')

module Api
  module V3
    class ProfilesController < Api::V1::ProfilesController
      def subscribe
        raise ApiErrors::UserDoesNotHaveAnotherPermissions unless params[:device_token]

        current_api_user.device_token = params[:device_token]
        current_api_user.device_platform = params[:device_platform]

        render json: { subscribed: current_api_user.save }
      end

      rescue_from StandardError do |e|
        raise ApiErrors::Base.new({ message: e.message })
      rescue ApiErrors::Base => err
        render_error_message(err)
      end

      private

      def render_error_message(error)
        message = error.message
        status = error.status || 500
        render json: {
          errors: [
            { message: message }
          ]
        }, status: status
      end
    end
  end
end
