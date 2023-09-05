require 'net/http'

class Client
  def initialize
    @http = Net::HTTP.new('localhost', '8888')
  end

  def get_auth_token
    response = @http.request_get('/auth')
    response['Badsec-Authentication-Token']
  end
end
