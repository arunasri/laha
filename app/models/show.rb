class Show < ActiveRecord::Base

  has_many :songs,    :class_name => 'Video', :conditions => "videos.kind ='song'"
  has_many :lyrics,   :class_name => 'Video', :conditions => "videos.kind ='lyric'"
  has_many :movies,   :class_name => 'Video', :conditions => "videos.kind ='movie'"
  has_many :trailers, :class_name => 'Video', :conditions => "videos.kind ='trailer'"
  has_many :videos

  validates :name,     :presence => true, :uniqueness => { :scope => :language }
  validates :language, :presence => true, :inclusion => { :in => %w(telugu hindi) }

  scope :telugu, where(:language => 'telugu')
  scope :hindi,  where(:language => 'hindi')

  before_save :update_year, :if => :started_on_changed?

  scope :released_in_year, lambda { |y| where(["year(shows.started_on) = ?", y]) }

  def default_thumbnail
    "http://i2.ytimg.com/vi/#{videos.first.try(:youtube_id)}/0.jpg"
  end

  def autocomplete_name
    "#{name} (#{language} #{year})"
  end

  def self.decode(pattern)
    if match = /(.*).\((telugu|hindi).(\d*)\)/.match(pattern)
      send(match[2]).where(:name => match[1]).tap do | proxy |
        proxy.released_in_year(match[3]) unless match[3].blank?
      end.first
    end
  end

  def update_year
    self.year = started_on.try(:year)
  end
end
