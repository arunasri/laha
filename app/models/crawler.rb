class Crawler
  attr_reader :feed
  attr_reader :page
  attr_reader :result
  attr_reader :failed
  attr_reader :processed

  cattr_accessor :client

  @@client = YouTubeG::Client.new

  def initialize(feed)
    reset
    @page = 1
    @feed = feed
  end

  def crawl
    @result = client.videos_by(:user => feed.name, :page => page)
  end

  def videos
    load_result.try(:videos)
  end

  def load_result
    @result || crawl
  end

  def next?
    !already_processed? && !end_of_feed?
  end

  #end of the feed
  def end_of_feed?
    load_result.videos.length < 25
  end

  def next!
    if next?
      reset
      @page = @page + 1
    else
      false
    end
  end

  def process!
    unless processed
      videos.each do | f |
        unless feed.add_youtube_video(f)
          @failed << f.unique_id
        end
      end
    end

    @processed = true
  end

  def reset
    @processed = false
    @result    = nil
    @failed    = []
  end

  def already_processed?
    process!

    feed.already_added?(failed) && feed.processed?
  end
end
