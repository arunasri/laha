class ShowsController < ApplicationController
  layout 'admin'

  before_filter :ensure_logged_in
  before_filter :ensure_admin_logged_in
  before_filter :set_current_videos_path, :only => [ :show, :edit ]

  def query
    @shows = Show.where(:name.like => "%#{params[:term]}%")
    respond_to do |format|
      format.js  { render :json => @shows.map(&:autocomplete_name) }
    end
  end


  # GET /shows
  # GET /shows.xml
  def index
    @shows = Show.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shows }
    end
  end

  # GET /shows/1
  # GET /shows/1.xml
  def show
    @show = Show.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @show }
    end
  end

  # GET /shows/new
  # GET /shows/new.xml
  def new
    @show = Show.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @show }
    end
  end

  def image
    @show = Show.find(params[:id])
    send_data @show.image, :type => 'image/jpg',:disposition => 'inline'
  end

  # GET /shows/1/edit
  def edit
    @show = Show.find(params[:id])
    @videos = @show.songs.paginate(:page => params[:page])
  end

  # POST /shows
  # POST /shows.xml
  def create
    @show = Show.new(params[:show])

    respond_to do |format|
      if @show.save
        format.html { redirect_to(edit_show_path(@show), :notice => 'Show was successfully created.') }
        format.xml  { render :xml => @show, :status => :created, :location => @show }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shows/1
  # PUT /shows/1.xml
  def update
    @show = Show.find(params[:id])

    respond_to do |format|
      if @show.update_attributes(params[:show])
        format.html { redirect_to(@show, :notice => 'Show was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.xml
  def destroy
    @show = Show.find(params[:id])
    @show.destroy

    respond_to do |format|
      format.html { redirect_to(shows_url) }
      format.xml  { head :ok }
    end
  end
end
