module AdminHelper
  def grouped_options_for_video_channels
    grouped_options_for_select([['Hindi', Channel.hindi.all.map {|c| [c.name,c.id] }],['Telugu', Channel.telugu.all.map {|c| [c.name, c.id] }]])
  end
end
