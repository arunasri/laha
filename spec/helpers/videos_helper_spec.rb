require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VideosHelper do
  context "#render_iframe_box" do
    subject { Factory(:video, :youtube_id => 23, :name => "some") }
    it "should render iframe with youtube player" do
      expected = '<iframe title="some" width="480" height="390" src="http://www.youtube.com/embed/23" frameborder="0" allowfullscreen></iframe>'

      assert_dom_equal expected, render_iframe_box(subject)
    end

    it "should use passed width and height" do
      expected = '<iframe title="some" width="480" height="300" src="http://www.youtube.com/embed/23" frameborder="0" allowfullscreen></iframe>'

      assert_dom_equal expected, render_iframe_box(subject, :height => 300)
    end
  end
end
