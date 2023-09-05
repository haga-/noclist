require_relative 'client'

client = Client.new
token  = client.get_auth_token
users  = client.get_users(token).split(/\n/)
p users
