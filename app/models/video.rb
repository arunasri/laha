class Video < ActiveRecord::Base

  acts_as_taggable

  attr_accessor   :show_name

  serialize  :keywords

  belongs_to :show
  belongs_to :feed,   :inverse_of => :videos
  belongs_to :channel

  validates :name,        :presence => true
  validates :youtube_id,  :presence => true, :uniqueness => true
  validates :quality,  :inclusion => { :in => %w(hd high medium low), :allow_nil => true }
  validates :language, :inclusion => { :in => %w(telugu hindi), :allow_nil => true }
  validates :kind,     :inclusion => { :in => %w(lyric song movie trailer), :allow_nil => true }
  validate  :validate_show_name

  before_validation :update_channel

  before_save :tag_changed, :if => :approved?

  scope :alive,       where(:deleted  => false)
  scope :deleted,     where(:deleted  => true )
  scope :approved,    where(:approved => true )
  scope :unapproved,  where(:approved => false)

  scope :after,   lambda { | date | where("videos.published_at > ?", date.to_time) }
  scope :before,  lambda { | date | where("videos.published_at < ?", date.to_time) }

  def after_initialize(options = {})
    @show_name = show.try(:autocomplete_name)
  end

  def self.in_admin_queue(channel)
    if !channel || channel == 'all'
      Video.scoped
    else
      Channel.find(channel).videos
    end.alive.unapproved
  end

  def assign_youtube_attributes(youtube)
    logger.info "processing youtube video: #{youtube.unique_id}"

    attrs = %w(keywords racy description duration published_at view_count)
    attrs.each { |a| send("#{a}=", youtube.send(a)) }

    self.name       = youtube.title
    self.category   = youtube.categories[0].term
    self.rating     = youtube.rating.try(:average)
    self.youtube_id = youtube.unique_id
  end

  def to_param
    # if the title has some special characters then parameterize uses something from ActiveSupport
    # which is not present in models and it throws exception. Hence ther rescue thing
    # https://rails.lighthouseapp.com/projects/8994/tickets/2308
    begin
      "#{id}-#{name.parameterize}"
    rescue Exception => e
      id.to_s
    end
  end

  def self.to_display(page)
    alive.order('published_at desc').approved.paginate(:page => page, :per_page => 50)
  end

  def self.know?(youtube)
    exists?(:youtube_id => youtube.unique_id)
  end

  def default_thumbnail
    "http://i2.ytimg.com/vi/#{youtube_id}/default.jpg"
  end

  # embed url
  # http://www.youtube.com/v/zDRJoNTJKLs&feature=youtube_gdata_player
  def embed_url
    "http://www.youtube.com/v/#{youtube_id}&feature=youtube_gdata_player"
  end

  # player_url
  # http://www.youtube.com/v/zDRJoNTJKLs&autoplay=1
  def player_url
    "http://www.youtube.com/v/#{youtube_id}&autoplay=1"
  end

  def bare_url
    "http://www.youtube.com/watch?v#{youtube_id}"
  end

  def delete!
    update_attribute(:deleted, true)
  end

  def show_name=(value)
    @show_name = value
    self.show_id = Show.decode(@show_name).try(:id)
  end

  def self.containing_tag(query)
    ActsAsTaggableOn::Tag.find_by_sql(%Q{
      SELECT distinct(tags.name),tags.id FROM tags LEFT OUTER JOIN taggings ON tags.id = taggings.tag_id INNER JOIN videos ON videos.id = taggings.taggable_id WHERE (taggings.taggable_type = 'Video') AND (lower(tags.name) like '%#{query.downcase}%')
    }).map { |x| { :id => x.id, :name => x.name } }
  end

  private

  def validate_show_name
    if @show_name && show_id.nil?
      errors.add(:show_name, "Unknown show name")
    end
  end

  def tag_changed
    %w(quality language kind name).each do | attr_name |
      replace_tag(send("#{attr_name}"), send("#{attr_name}_was"))
    end

    replace_tag(show.try(:name), Show.find_by_id(show_id_was).try(:name))
  end

  def replace_tag(new_tag, old_tag)
    unless old_tag.blank?
      self.tag_list.delete(old_tag)
    end

    unless new_tag.blank?
      self.tag_list << new_tag
    end
  end

  def update_channel
    if kind && language
      self.channel = Channel.send(language).where(:show_association_name => kind.pluralize).first
    end
  end
end
