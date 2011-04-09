require 'youtube_g'
class YouTubeG
  module Request #:nodoc:
    class PlaylistSearch < BaseSearch #:nodoc:
      attr_reader :max_results                     # max_results
      attr_reader :order_by                        # orderby, ([relevance], viewCount, published, rating)
      attr_reader :offset                          # start-index

      def initialize(playlist, options={})
        @max_results, @order_by, @offset = nil

        @url = base_url + playlist.to_s << build_query_params(to_youtube_params)
      end

      private

      def base_url
        super << "playlists/"
      end

      def to_youtube_params
        {
          'max-results' => @max_results,
          'orderby' => @order_by,
          'start-index' => @offset
        }
      end
    end
  end
end

class YouTubeG
  module Parser #:nodoc:

    class PlaylistParser < VideoFeedParser #:nodoc:

    private
      def parse_content(content)
        doc = REXML::Document.new(content)
        feed = doc.elements["feed"]

        feed_id = feed.elements["id"].text
        updated_at = Time.parse(feed.elements["updated"].text)
        total_result_count = feed.elements["openSearch:totalResults"].text.to_i
        offset = feed.elements["openSearch:startIndex"].text.to_i
        max_result_count = feed.elements["openSearch:itemsPerPage"].text.to_i

        videos = []
        feed.elements.each("entry") do |entry|
          video_link = entry.elements.each("link[@rel='alternate']") {|x| x.name }.first.attributes["href"]
          videos << CGI.parse(video_link)["http://www.youtube.com/watch?v"].first
        end

        YouTubeG::Response::VideoSearch.new(
          :feed_id => feed_id,
          :updated_at => updated_at,
          :total_result_count => total_result_count,
          :offset => offset,
          :max_result_count => max_result_count,
          :videos => videos)
      end
    end
  end
end
