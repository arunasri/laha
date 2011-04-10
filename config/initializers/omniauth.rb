require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,'60710595ffa243d6ad57ea3fc5759740', 'e2b49b334c993fb13a15ff50a5e68989'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end
