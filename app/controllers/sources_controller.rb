class SourcesController < ApplicationController

  def index
    @search_params = search_params
    @sources = Source.by_search_params(@search_params)
  end

  def new
    @source = Source.new
  end

  def edit
    @source = Source.find params[:id]
  end

  def show
    @source = Source.find params[:id]
    authorize! :read, @source
    @approval = @source.approval_by current_user
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
    authorize! :create, Source
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
    authorize! :update, @source
    @source.update source_params
    if (@source.save)
      redirect_to source_url(@source)
    else
      render 'edits'
    end
  end

  def destroy
    @source = Source.find params[:id]
    authorize! :destroy, @source
    if @source.destroy
      flash[:success] = 'Source removed succesfully!'
      redirect_to sources_url
    else
      flash[:danger] = 'Could not delete Source...'
      redirect_to source_url(@source)
    end
  end

  protected
  def source_params
    params.require(:source).permit(
      :title,
      :authors,
      :year,
      :bibtex_type,
      :keywords,
      :abstract,
      :url,
      :search_database,
      :search_query,
      :document,
      :isbn,
      :doi,
      :editors,
      :subtitle,
      :shorttitle,
      :month,
      :publisher,
      :institution,
      :organization,
      :school,
      :address,
      :edition,
      :series,
      :chapter,
      :pages,
      :journal,
      :number,
      :volume,
      :note
    )
  end

  def search_params
    params.permit(:q, :sort)
  end

end
