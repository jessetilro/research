class SourcesController < ApplicationController

  def index
    @sources = Source.by_search_query(params[:q])
  end

  def new
    @source = Source.new
  end

  def edit
    @source = Source.find params[:id]
  end

  def show
    @source = Source.find params[:id]
    disposition = params.key?(:download) ? 'attachment' : 'inline'
    respond_to do |format|
      format.html
      format.pdf do
        send_file File.realpath(@source.document.path),
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

  def update
    @source = Source.find params[:id]
    @source.update source_params
    if (@source.save)
      redirect_to source_url(@source)
    else
      render 'edits'
    end
  end

  def destroy
    @source = Source.find params[:id]
    if @source.destroy
      flash[:success] = 'Source removed succesfully!'
      redirect_to sources_url
    else
      flash[:error] = 'Could not delete Source...'
      redirect_to source_url(@source)
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
      :search_database,
      :search_query,
      :abstract,
      :description,
      :document
    )
  end

end
