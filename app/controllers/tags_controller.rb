class TagsController < ApplicationController
  def search
    @tags = Video.containing_tag(params[:term])
    respond_to do |format|
      format.js  { render :json => @tags }
    end
  end
end
