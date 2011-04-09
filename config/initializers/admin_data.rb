AdminData.config do |config|
  p = lambda { |controller|
            return true if controller.current_user && AppConfig.admin_emails.include?(controller.current_user.email)
        }

  config.is_allowed_to_view = p

  config.is_allowed_to_update = p

end
