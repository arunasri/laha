require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe ChannelsController do

  def mock_channel(stubs={})
    @mock_channel ||= mock_model(Channel, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all channels as @channels" do
      Channel.stub(:all) { [mock_channel] }
      get :index, :language => 'telugu'
      assigns(:channels).should eq([mock_channel])
    end
  end

  describe "GET show" do
    it "assigns the requested channel as @channel" do
      Channel.stub(:where).with(:language => "telugu", :name => "37") { mock_channel }
      get :show, :id => "37", :language => 'telugu'
      assigns(:channel).should be(mock_channel)
    end
  end

  describe "GET new" do
    it "assigns a new channel as @channel" do
      Channel.stub(:new) { mock_channel }
      get :new, :language => 'telugu'
      assigns(:channel).should be(mock_channel)
    end
  end

  describe "GET edit" do
    it "assigns the requested channel as @channel" do
      Channel.stub(:find).with("37") { mock_channel }
      get :edit, :id => "37", :language => 'telugu'
      assigns(:channel).should be(mock_channel)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested channel" do
        Channel.stub(:find).with("37") { mock_channel }
        mock_channel.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :channel => {'these' => 'params'}, :language => 'telugu'
      end

      it "assigns the requested channel as @channel" do
        Channel.stub(:find) { mock_channel(:update_attributes => true) }
        put :update, :id => "1", :language => 'telugu'
        assigns(:channel).should be(mock_channel)
      end

      it "redirects to the channel" do
        Channel.stub(:find) { mock_channel(:update_attributes => true) }
        put :update, :id => "1", :language => 'telugu'
        response.should redirect_to(channel_url(mock_channel))
      end
    end

    describe "with invalid params" do
      it "assigns the channel as @channel" do
        Channel.stub(:find) { mock_channel(:update_attributes => false) }
        put :update, :id => "1", :language => 'telugu'
        assigns(:channel).should be(mock_channel)
      end

      it "re-renders the 'edit' template" do
        Channel.stub(:find) { mock_channel(:update_attributes => false) }
        put :update, :id => "1", :language => 'telugu'
        response.should render_template("edit")
      end
    end
  end

end
