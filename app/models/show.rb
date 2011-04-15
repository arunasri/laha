class Show < ActiveRecord::Base

  serialize :data
  serialize :image

  has_many :songs,    :class_name => 'Video', :conditions => "videos.kind ='song'"
  has_many :lyrics,   :class_name => 'Video', :conditions => "videos.kind ='lyric'"
  has_many :movies,   :class_name => 'Video', :conditions => "videos.kind ='movie'"
  has_many :trailers, :class_name => 'Video', :conditions => "videos.kind ='trailer'"
  has_many :videos

  validates :name,     :presence => true, :uniqueness => { :scope => :language }, :unless => :new_record?
  validates :language, :presence => true, :inclusion => { :in => %w(telugu hindi) }, :unless => :new_record?

  scope :telugu, where(:language => 'telugu')
  scope :hindi,  where(:language => 'hindi')

  before_save :update_year, :if => :started_on_changed?
  before_validation :extract_show_info_from_page, :if => :url?

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

  def sync
    self.name = extract_name
    self.year = extract_year
    self.cast = extract_cast
    unless Rails.env.test?
      image_url = document.css("img.blackBdr").first.attributes["src"].value
      self.image = open(image_url).read
    end
    self.music_director = extract_music_director
    extract_songs
  end

  private

  def extract_show_info_from_page
    if new_record?
      (self.data ||= load_page(self.url)) && sync
    end
  end

  def movie_document
    @_movie ||= document.css(".dataTbl.r-rounded.grayBdr.r-shadow").first
  end

  def title_document
    @_title ||= movie_document.css("tr:nth-child(1) td.contentMainHead")
  end

  def title_and_year
    title_document.inner_text.gsub(/\t/,'').gsub(/\n/,"").strip
  end

  def extract_name
    title_and_year.match(/(\()(\d+)(\))/).pre_match.strip.gsub(/\r/,'').gsub(/\t/,'')
  end

  def extract_year
    title_and_year.match(/(\()(\d+)(\))/)[2]
  end

  def extract_cast
    movie_document.css("tr:nth-child(3) td.blackNoLine:last").map(&:text).map(&:strip).join(", ")
  end

  def extract_music_director
    movie_document.css("tr:nth-child(2) td.black a").map(&:text).join(",")
  end

  def extract_songs
    document.css(".dataTbl.clipDet").each { | song | make_song(song) }
  end

  def make_song(song)
    args = { :language => self.language }

    title = song.css(".lftFlt1 a.contentSubHead")
    id    = title.first.attributes["onclick"].value.match(/(\()(\d+)(\))/)[2]

    args.update({
      :name     => title.text,
      :singers  => song.css("#trackDetails#{id} div").first.css("a").map(&:text).join(","),
      :writer   => song.css("#trackDetails#{id} div").last.css("a").map(&:text).join(",")
    })

    songs.build(args.merge(:kind => 'song'))
  end

  def load_page(url)
    open(url).read
  end

  def document
    @document ||= Nokogiri::HTML(self.data)
  end
end
