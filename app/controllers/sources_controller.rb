class SourcesController < ApplicationController

  def index
    @sources = Source.by_search_query(params[:q])
  end

  def new
    @source = Source.new
  end

  def create
    @source = Source.new(source_params)
    @source.user = current_user
    if (@source.save)
      redirect_to sources_url
    else
      render 'new'
    end
  end

  protected
  def source_params
    params.require(:source).permit(
      :title,
      :authors,
      :year,
      :kind,
      :url,
      :abstract,
      :description
    )
  end

end
