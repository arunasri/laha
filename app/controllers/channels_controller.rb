class ChannelsController < ApplicationController

  skip_before_filter :ensure_logged_in,       :only => [:show, :index, :play_all]
  skip_before_filter :ensure_admin_logged_in, :only => [:show, :index, :play_all]
  before_filter      :update_channel_preference,  :only => [ :show ]

  caches_page :show

  def index
    @channels = Channel.all

    if is_mobile_device?
      clear_preference
    end

    if language? && channel?
      redirect_to channel_path(:language => language, :id => channel)
    else
      respond_to do |format|
        format.mobile
        format.html
      end
    end
  end

  def show
    @channel = Channel.where(:language => language, :name => channel).first
    @videos  = @channel.videos.to_display(params[:page])

    respond_to do |format|
      format.mobile
      format.html
    end
  end

  def new
    @channel = Channel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @channel }
    end
  end

  def edit
    @channel = Channel.find(params[:id])
  end

  def update
    @channel = Channel.find(params[:id])

    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        format.html { redirect_to(@channel, :notice => 'Channel was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
end
