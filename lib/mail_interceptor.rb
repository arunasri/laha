class MailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = AppConfig.intercepted_emails_should_go_to
  end
end
