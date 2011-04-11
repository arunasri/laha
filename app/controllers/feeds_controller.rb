class FeedsController < ApplicationController

  layout 'admin'

  before_filter :ensure_logged_in
  before_filter :ensure_admin_logged_in
  before_filter :set_current_videos_path, :only => [ :show, :edit ]

  # GET /feeds
  # GET /feeds.xml
  def index
    @feeds = Feed.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.xml
  def show
    @feed = Feed.find(params[:id])
    @search = @feed.videos.search(params[:search])
    @videos = @feed.videos.unapproved.paginate(:page => params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.xml
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/1/latest
  def latest
    @feed = Feed.find(params[:id])
    @feed.latest

    respond_to do |format|
      format.js { render :json => @feed.videos.count }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
    @search = @feed.videos.search(params[:search])
    @videos = @feed.videos.paginate(:page => params[:page], :per_page => 10)
  end

  # POST /feeds
  # POST /feeds.xml
  def create
    @feed = Feed.new(params[:feed])

    respond_to do |format|
      if @feed.save
        format.html { redirect_to(feeds_url, :notice => 'Feed was successfully created.') }
        format.xml  { render :xml => @feed, :status => :created, :location => @feed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.xml
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to(current_videos_path || @feed, :notice => 'Feed was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.xml
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to(feeds_url) }
      format.xml  { head :ok }
    end
  end
end
