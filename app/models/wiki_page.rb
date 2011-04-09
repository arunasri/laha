class WikiPage < ActiveRecord::Base
  serialize :data
  before_validation :load_page
  validates :data,      :presence => true
  validates :url,       :presence => true
  validates :language,  :presence => true

  scope :hindi,   where(:language => 'hindi')
  scope :telugu,  where(:language => 'telugu')

  def self.load
    config = YAML::load_file("#{Rails.root}/db/wiki.yml")
    config.keys.each do | lang |
      config[lang].each do | url |
        create(:language => lang, :url => url )
      end
    end
  end

  def document
    @document ||= Nokogiri::HTML(self.data)
  end

  private

  def load_page
    Rails.logger.info("loading #{url}")
    self.data ||= open(url).read
  end
end
