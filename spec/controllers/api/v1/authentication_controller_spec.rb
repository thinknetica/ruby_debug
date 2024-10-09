require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  let(:user) { create :user, :volunteer }

  describe 'POST #refresh_token' do
    include_context 'jwt authenticated'

    it 'returns a new token and expiration date' do
      request.headers['Authorization'] = default_headers.values.first
      post :refresh_token
    end
  end
end
