require 'net/http'
require 'digest'

class Client
  class Error < StandardError
    def initialize(response, path)
      super("Error on path: '#{path}'\nStatus Code: #{response.code}, Body: #{response.body}")
    end
  end

  def initialize
    @http = Net::HTTP.new('localhost', '8888')
  end

  def get_auth_token
    response = retryable_get('/auth')
    response['Badsec-Authentication-Token']
  end

  def get_users(token)
    response = @http.request_get(
      '/users',
      { 'X-Request-Checksum' => Digest::SHA256.hexdigest("#{token}/users") }
    )
    response.body
  end

  private

  def retryable_get(path)
    @retry_count ||= 0
    response = @http.request_get(path)
    raise Client::Error.new(response, path) if response.code != '200'
    response
  rescue StandardError => e
    @retry_count += 1
    if @retry_count < 3
      retryable_get(path)
    else
      @retry_count = nil
      raise e
    end
  end
end
