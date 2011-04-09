class Cron < ActiveRecord::Base
  validates :name, :presence => true
end
