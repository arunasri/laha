require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'QncgFiPxJMtU0jXd8rTmw','wXJlzIKC1M1WuG9elCOMq9nWknH0pYN9A782bQ3sjgo'
  provider :facebook,'e740e7098815ce21d64a1e238b891b89','ddd5b1dd54b2eb99fb9b79835d1a0fc8'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end
