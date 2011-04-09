def l(msg)
  Rails.logger.info(msg)
  puts(msg)
end

desc "load latest youtube videos"
task :update_videos => :environment do
  Feed.all.each do | feed |
    begin
      l "feed: #{feed.name}"
      feed.latest
    rescue => e
      l e.message
      l e.backtrace
    end
  end
end
