class Feed < ActiveRecord::Base

  validates  :name, :uniqueness => true, :presence => true

  has_many :videos, :autosave => true, :inverse_of => :feed do
    def add_youtube_video(y)
      build.tap { |t| t.assign_youtube_attributes(y) }
    end
  end

  def latest
    self.class.transaction do
      crawler = Crawler.new(self)

      begin
        logger.info "processing page: #{crawler.page}"
        crawler.crawl
        crawler.process!
      end while crawler.next!

      self.processed = true
      save
    end
  end

  def add_youtube_video(youtube)
    !Video.know?(youtube) && videos.add_youtube_video(youtube)
  end

  def already_added?(youtube_ids)
    videos.where(:youtube_id => youtube_ids).count > 0
  end
end
