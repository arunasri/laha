class Emailtb < ActiveRecord::Base

  serialize :data

  validates :data, :presence => true

  after_create :enqueue_it

  def self.reset_password(user)
    data = {:subject => 'Reset password', :recipients => [user.id], :template => 'reset_password' }
    self.create(:data => data)
  end

  def enqueue_it
    priority = data[:template] == 'reset_password_instruction' ? 100 : 0
    Delayed::Job.enqueue NotifierJob.new(self.id), :priority => priority
  end

end

