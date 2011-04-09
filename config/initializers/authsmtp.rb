if AppConfig.use_autsmtp == 'true'
  ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    :address => AppConfig.authsmtp_address,
    :port => AppConfig.authsmtp_port,
    :user_name => AppConfig.authsmtp_user_name,
    :password => AppConfig.authsmtp_password,
    :authentication => :plain
  }
end

