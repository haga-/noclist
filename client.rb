require 'net/http'
require 'digest'

class Client
  def initialize
    @http = Net::HTTP.new('localhost', '8888')
  end

  def get_auth_token
    response = @http.request_get('/auth')
    response['Badsec-Authentication-Token']
  end

  def get_users(token)
    response = @http.request_get(
      '/users',
      { 'X-Request-Checksum' => Digest::SHA256.hexdigest("#{token}/users") }
    )
    response.body
  end
end
