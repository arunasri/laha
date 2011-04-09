require "spec_helper"

describe TagsController do
  describe "routing" do
    it "recognizes and generates #search" do
      { :get => "/tags/search" }.should route_to(:controller => "tags", :action => "search")
    end
  end
end
