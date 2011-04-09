class Channel < ActiveRecord::Base

  has_many :feeds, :foreign_key => :default_channel_id

  has_many :videos

  has_many :shows, :through => :videos

  validates :name, :presence => true
  validates :show_association_name, :presence => true

  validates :language, :inclusion => { :in => %w(telugu hindi) }

  scope :by_association,  lambda { | name | where(:show_association_name => name) }
  scope :hindi,   where(:language => 'hindi')
  scope :telugu,  where(:language => 'telugu')


  def self.build_from_config
    # this allows one to move a feed from one channel to another channel in channels.yml
    # also it allows one to delete a channel
    Feed.delete_all

    config = YAML::load_file("#{Rails.root}/db/channels.yml")
    config.keys.each do | lang |
      config[lang].each do | channel_name, options |
        options.symbolize_keys!
        options.update(:language => lang)
        feeds = options.delete(:feeds)
        channel = Channel.where(options).first || Channel.create(options)
        feeds.each_pair do | name, approved |
          channel.feeds.create(:name => name, :approved => approved)
        end
      end
    end
  end
end
