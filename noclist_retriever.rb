require_relative 'client'

client = Client.new
token  = client.get_auth_token
p token
