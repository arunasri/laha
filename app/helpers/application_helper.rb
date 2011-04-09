module ApplicationHelper

  def in_place_editor(video, property, options = {})
    klass_name = "#{options.delete(:class)} best_in_place"
    content_tag(:span, video.send(property).try(:to_s).try(:humanize), { :class => klass_name, :"data-url" => "/videos/#{video.id}", "data-object" => "video", "data-attribute" => "#{property}", "data-type" => "textarea"}.merge(options))
  end

  def facebook_like(video_id)
    id = video_id.to_s
    %Q{
      <iframe src="http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fhamarabox.com%2Fvideos%2F#{id}&amp;layout=button_count&amp;show_faces=true&amp;width=450&amp;action=like&amp;colorscheme=light&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:450px; height:21px;" allowTransparency="true"></iframe>
    }
  end
end
