#!/usr/bin/env ruby

require_relative 'client'

begin
  client = Client.new
  token  = client.get_auth_token
  users  = client.get_users(token).split(/\n/)
  p users
rescue StandardError => e
  puts e.message
  exit 1
end
