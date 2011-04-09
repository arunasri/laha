require "spec_helper"

describe ChannelsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/hindi/channels" }.should route_to(:controller => "channels", :action => "index", :language => 'hindi')
    end

    it "recognizes and generates #new" do
      { :get => "/hindi/channels/new" }.should route_to(:controller => "channels", :action => "new", :language => 'hindi')
    end

    it "recognizes and generates #show" do
      { :get => "/hindi/channels/1" }.should route_to(:controller => "channels", :action => "show", :id => "1",:language => 'hindi')
    end

    it "recognizes and generates #edit" do
      { :get => "/hindi/channels/1/edit" }.should route_to(:controller => "channels", :action => "edit", :id => "1", :language => 'hindi')
    end

    it "recognizes and generates #update" do
      { :put => "/hindi/channels/1" }.should route_to(:controller => "channels", :action => "update", :id => "1", :language => 'hindi')
    end

  end
end
