# frozen_string_literal: true
require Rails.root.join('lib/api_errors/base')
require Rails.root.join('lib/api_errors/message_handler')

module Api
  module V3
    class BaseController < Api::V1::BaseController

      rescue_from ApiErrors::Base do |e|
        render_error_message(e)
      end

      private

      def authorize_request
        @current_api_user = User.volunteers.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        raise ApiErrors::UserNotFoundError
      rescue JWT::DecodeError => e
        raise ApiErrors::UserDoesNotHaveSomePermissions
      end

    end
  end
end
