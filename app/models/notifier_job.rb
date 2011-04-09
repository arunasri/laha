require 'hoptoad_notifier'

class NotifierJob < Struct.new(:emailtb_id)

  def perform
    emailtb = Emailtb.find(emailtb_id)
    data = emailtb.data
    data.fetch(:recipient).each do |user_id|
      e = Mailer.send(data[:template], emailtb, user_id).deliver!
      #@transaction_id = e.transaction_id
    end
  end

  def after(job)
    emailtb = Emailtb.find(emailtb_id)
    emailtb.update_attribute(:sent_at, Time.now)
  end

  def error(job, exception)
    HoptoadNotifier.notify(exception, {:api_key => AppConfig.hoptoad_api_key, :environment => 'production'})
  end

end
