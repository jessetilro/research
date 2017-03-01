class SourcesController < ApplicationController

  def index
    @sources = Source.by_search_query(params[:q])
  end

  def new
    @source = Source.new
  end

  def show
    @source = Source.find params[:id]
    disposition = params.key?(:download) ? 'attachment' : 'inline'
    respond_to do |format|
      format.html
      format.pdf do
        send_file @source.document.path,
          type: @source.document.content_type,
          disposition: disposition
      end
    end
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
      :description,
      :document
    )
  end

end
