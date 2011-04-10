class PlayersController < ApplicationController

  skip_before_filter :ensure_logged_in
  skip_before_filter :ensure_admin_logged_in

  def play
    @playing  = (params[:term] || '').split(",").reject(&:blank?)
    @playing  = ActsAsTaggableOn::Tag.find(@playing).map(&:name)

    @videos   = Video.approved
    @videos   = @videos.tagged_with(@playing) unless @playing.blank?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @videos.map { |r| r.attributes.slice("youtube_id") } }
    end
  end

  def next
    @playing  = (params[:term] || 'telugu').split(",").reject(&:blank?)
    proxy     = Video.approved
    proxy     = proxy.tagged_with(@playing) unless @playing.blank?
    @videos   = proxy.to_ary.map(&:youtube_id)

    respond_to do |format|
      format.js { render :json => @videos }
    end
  end
end
