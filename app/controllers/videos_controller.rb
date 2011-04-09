class VideosController < ApplicationController

  layout 'admin'

  before_filter :ensure_logged_in
  before_filter :ensure_admin_logged_in

  def index
    @search = Video.unapproved.search(params[:search])
    @videos = Video.unapproved.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def shows
    @shows = Show.where(:name.like => "%#{params[:term]}%").map(&:name)

    respond_to do |format|
      format.js  { render :json => @shows  }
    end
  end

  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @video = Video.find(params[:id])
  end

  def create
    @video = Video.new(params[:video])

    respond_to do |format|
      if @video.save
        format.html do
          redirect_to(edit_video_path(@video), :notice => 'Video was successfully created.')
        end
      else
        format.html do
          flash[:error] = 'Failed to save youtube video url.'
          render :action => 'new'
        end
      end
    end
  end

  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to current_videos_path || edit_video_path(Video.unapproved.first) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to(videos_path) }
      format.json { head :ok }
    end
  end
end
