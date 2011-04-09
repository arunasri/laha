require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedsController do
  before(:each) do
    @controller.stub(:ensure_admin_logged_in).and_return(true)
    @controller.stub(:current_user).and_return(User.new)
  end

  def mock_feed(stubs={})
    @mock_feed ||= mock_model(Feed, stubs).as_null_object
  end

  describe "GET new" do
    it "assigns a new video as @video" do
      Feed.stub(:new) { mock_feed }
      get :new
      assigns(:feed).should be(mock_feed)
    end
  end

  describe "GET edit" do
    it "assigns the requested video as @video" do
      Feed.stub(:find).with("37") { mock_feed }
      get :edit, :id => "37"
      assigns(:feed).should be(mock_feed)
    end
  end

  describe "GET show" do
    it "assigns the requested video as @video" do
      Feed.stub(:find).with("37") { mock_feed }
      get :show, :id => "37"
      assigns(:feed).should be(mock_feed)
      session[:videos_path].should eql("/feeds/37")
      @controller.current_videos_path.should eql("/feeds/37")
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created video as @video" do
        Feed.stub(:new).with({'these' => 'params'}) { mock_feed(:save => true) }
        post :create, :feed => {'these' => 'params'}
        assigns(:feed).should be(mock_feed)
      end

      it "redirects to the created video edit" do
        Feed.stub(:new) { mock_feed(:save => true) }
        post :create, :feed => {}
        response.should redirect_to(feeds_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved video as @video" do
        Feed.stub(:new).with({'these' => 'params'}) { mock_feed(:save => false) }
        post :create, :feed => {'these' => 'params'}
        assigns(:feed).should be(mock_feed)
      end

      it "re-renders the 'new' template" do
        Feed.stub(:new) { mock_feed(:save => false) }
        post :create, :feed => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested video" do
        Feed.stub(:find).with("37") { mock_feed }
        mock_feed.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :feed => {'these' => 'params'}
      end

      it "assigns the requested video as @video" do
        Feed.stub(:find) { mock_feed(:update_attributes => true) }
        put :update, :id => "1", :feed => {}
        assigns(:feed).should be(mock_feed)
      end

      it "redirects to the video" do
        Feed.stub(:find) { mock_feed(:update_attributes => true) }
        put :update, :id => "1", :feed => {}
        response.should redirect_to(feed_path(mock_feed))
      end
    end

    describe "with invalid params" do
      it "assigns the video as @video" do
        Feed.stub(:find) { mock_feed(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:feed).should be(mock_feed)
      end

      it "re-renders the 'edit' template" do
        Feed.stub(:find) { mock_feed(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested video" do
      Feed.stub(:find).with("37") { mock_feed }
      mock_feed.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the videos list" do
      Feed.stub(:find) { mock_feed }
      delete :destroy, :id => "1"
      response.should redirect_to(feeds_url)
    end
  end

end
