require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VideosController do

  before(:each) do
    @controller.stub(:ensure_logged_in).and_return(true)
    @controller.stub(:ensure_admin_logged_in).and_return(true)
  end

  def mock_video(stubs={})
    @mock_video ||= mock_model(Video, stubs).as_null_object
  end

  describe "GET new" do
    it "assigns a new video as @video" do
      Video.stub(:new) { mock_video }
      get :new
      assigns(:video).should be(mock_video)
    end
  end

  describe "GET edit" do
    it "assigns the requested video as @video" do
      Video.stub(:find).with("37") { mock_video }
      get :edit, :id => "37"
      assigns(:video).should be(mock_video)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created video as @video" do
        Video.stub(:new).with({'these' => 'params'}) { mock_video(:save => true) }
        post :create, :video => {'these' => 'params'}
        assigns(:video).should be(mock_video)
      end

      it "redirects to the created video edit" do
        Video.stub(:new) { mock_video(:save => true) }
        post :create, :video => {}
        response.should redirect_to(edit_video_url(mock_video))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved video as @video" do
        Video.stub(:new).with({'these' => 'params'}) { mock_video(:save => false) }
        post :create, :video => {'these' => 'params'}
        assigns(:video).should be(mock_video)
      end

      it "re-renders the 'new' template" do
        Video.stub(:new) { mock_video(:save => false) }
        post :create, :video => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested video" do
        Video.stub(:find).with("37") { mock_video }
        mock_video.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :video => {'these' => 'params'}
      end

      it "assigns the requested video as @video" do
        Video.stub(:find) { mock_video(:update_attributes => true) }
        put :update, :id => "1", :video => {}
        assigns(:video).should be(mock_video)
      end

      it "redirects to the video" do
        Video.stub(:find) { mock_video(:update_attributes => true) }
        Video.stub(:unapproved) { mock_video(:id => 2) }
        put :update, :id => "1", :video => {}
        response.should redirect_to(edit_video_path(mock_video(:id => 2)))
      end
    end

    describe "with invalid params" do
      it "assigns the video as @video" do
        Video.stub(:find) { mock_video(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:video).should be(mock_video)
      end

      it "re-renders the 'edit' template" do
        Video.stub(:find) { mock_video(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested video" do
      Video.stub(:find).with("37") { mock_video }
      mock_video.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the videos list" do
      Video.stub(:find) { mock_video }
      delete :destroy, :id => "1"
      response.should redirect_to(videos_url)
    end
  end
end
