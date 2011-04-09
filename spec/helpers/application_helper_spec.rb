require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  context "best_in_place_editor" do
    it "should create span tag for the attribute" do
      expected = %q{<span class=' best_in_place' data-url='/videos/2' data-object='video' data-attribute='name' data-type='textarea'>Kokila</span>}
      video = double(:id =>2, :name => 'Kokila')
      assert_dom_equal expected, in_place_editor(video, :name)
    end

    it "should create span tag for the attribute and class" do
      expected = %q{<span class='text best_in_place' data-url='/videos/2' data-object='video' data-attribute='name' data-type='textarea'>Kokila</span>}
      video = double(:id =>2, :name => 'Kokila')
      assert_dom_equal expected, in_place_editor(video, :name, :class => "text")
    end
  end
end
