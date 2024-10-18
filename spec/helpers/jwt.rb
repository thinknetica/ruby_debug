def jwt_authenticated_header(user)
  time = Time.now + 1.hour
  token = JsonWebToken.encode({ user_id: user.id, exp: time })
  # if self.inspect.match?(/help_requests_spec.rb:12/)
  #   binding.pry
  # end

  # if !$bo;$bo=true;binding.pry;end
  { 'Authorization': "Bearer #{token}" }
end
