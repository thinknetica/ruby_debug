require 'json'
require 'uri'
require 'httparty'

class TodoService
  BASE_URL = 'https://jsonplaceholder.typicode.com/todos'.freeze

  def fetch_todo(id)
    uri = URI("#{BASE_URL}/#{id}")
    response = HTTParty.get(uri, headers: jwt_authenticated_header)
    JSON.parse(response.body)
  rescue StandardError => e
    { error: e.message }
  end

  private

  def jwt_authenticated_header
    time = Time.now + 1.hour
    token = JsonWebToken.encode({ all: "good", exp: time })
    { 'Authorization': "Bearer #{token}" }
  end

end