require 'rails_helper'

RSpec.describe 'Routing', type: :routing do

  before :all do
    HelpRequestKind.instance_eval do
      def count;3;end
    end
  end

  routes_to_test = [
    { method: :post, path: '/users/sign_in', controller: 'sessions', action: 'create' },
    { method: :post, path: '/users', controller: 'registrations', action: 'create' },
    { method: :post, path: '/users/password', controller: 'passwords', action: 'create' },
    { method: :post, path: '/users/confirmation', controller: 'confirmations', action: 'create' },

    { method: :post, path: '/api/v1/login', controller: 'api/v1/authentication', action: 'login' },
    { method: :post, path: '/api/v1/refresh_token', controller: 'api/v1/authentication', action: 'refresh_token' },
    { method: :get, path: '/api/v1/profile', controller: 'api/v1/profiles', action: 'show' },
    { method: :post, path: '/api/v1/subscribe', controller: 'api/v1/profiles', action: 'subscribe' },
    { method: :delete, path: '/api/v1/unsubscribe', controller: 'api/v1/profiles', action: 'unsubscribe' },
    { method: :get, path: '/api/v1/help_requests', controller: 'api/v1/help_requests', action: 'index' },
    { method: :get, path: '/api/v1/scores', controller: 'api/v1/scores', action: 'index' },
    { method: :post, path: '/api/v1/help_requests/1/assign', controller: 'api/v1/help_requests', action: 'assign', id: '1' },
    { method: :post, path: '/api/v1/help_requests/1/submit', controller: 'api/v1/help_requests', action: 'submit', id: '1' },
    { method: :post, path: '/api/v1/help_requests/1/refuse', controller: 'api/v1/help_requests', action: 'refuse', id: '1' },

    { method: :get, path: '/admin/dashboard', controller: 'admin/dashboard', action: 'index' },
    { method: :post, path: '/admin/recurring', controller: 'admin/manual_pushes', action: 'recurring' },
    { method: :get, path: '/admin/help_requests', controller: 'admin/help_requests', action: 'index' },
    { method: :post, path: '/admin/help_requests', controller: 'admin/help_requests', action: 'create' },
    { method: :get, path: '/admin/help_requests/1/edit', controller: 'admin/help_requests', action: 'edit', id: '1' },
    { method: :get, path: '/admin/users', controller: 'admin/users', action: 'index' },
    { method: :get, path: '/admin/organizations', controller: 'admin/organizations', action: 'index' },
    { method: :get, path: '/admin/settings', controller: 'admin/settings', action: 'index' },

    { method: :get, path: '/pages/confirm_email', controller: 'pages', action: 'confirm_email' },
    { method: :get, path: '/pages/waiting_for_moderator', controller: 'pages', action: 'waiting_for_moderator' }
  ]

  # Single loop to test all routes
  routes_to_test.each do |route|
    it "routes #{route[:method].upcase} #{route[:path]} to #{route[:controller]}##{route[:action]}" do
      # if self.inspect.match?(/registrations#create/)
      #   binding.pry
      # end
      # if !$bo;$bo=true;binding.pry;end
      expect(route[:method] => route[:path]).to route_to(route.except(:method, :path))
    end
  end
end
