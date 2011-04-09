require 'mad_mimi_mail'
require 'mad_mimi_mailer'

MadMimiMail::Configuration.api_settings = {:email => AppConfig.mad_mimi_user_email,
                                           :api_key => AppConfig.mad_mimi_api_key}

class Mailer < MadMimiMailer

  layout 'mailer'

  default :from => AppConfig.from_email

  def reset_password(emailtb, recipient_user_id)
    @user = User.find(recipient_user_id)
    @user.generate_altp
    @reset_password_link = AppConfig.base_url + "/reset_passwords/#{@user.altp}"
    notify_recipient(emailtb, recipient_user_id)
  end

  def notify_recipient(emailtb, recipient_user_id)
    subject = AppConfig.email_subject_prefix + ' ' + emailtb.data.fetch(:subject)
    mail(:to => User.find(recipient_user_id).email,
         :subject => subject,
         :promotion_name => AppConfig.mad_mimi_promotion_name)
  end

end

