# Except production do not send email to real users
require "#{Rails.root}/lib/mail_interceptor"

Mail.register_interceptor(MailInterceptor) unless Rails.env.production?

