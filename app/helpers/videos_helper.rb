module VideosHelper

  def render_video_box(video, options)
    div_for(video,  :class => options[:class], :width => options[:width], :height => options[:height],
    :link => video.youtube_id) do
    end
  end

  def render_iframe_box(video, options = {})
    options.reverse_merge! :width => 480, :height => 390
    height = options[:height]
    width = options[:width]
    %Q{<iframe title="#{video.name}" width="#{width}" height="#{height}" src="http://www.youtube.com/embed/#{video.youtube_id}" frameborder="0" allowfullscreen></iframe>}.html_safe
  end
end
