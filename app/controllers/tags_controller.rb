class TagsController < ApplicationController
  def search
    @tags = Video.containing_tag(params[:term])

    if params[:exact]
      @tags = @tags.find { |x| x[:name] == params[:term] }
    end

    respond_to do |format|
      format.js  { render :json => @tags }
    end
  end
end
