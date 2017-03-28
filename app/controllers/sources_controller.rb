class SourcesController < ApplicationController
  include Searching
  include Breadcrumbs
  include ProjectScoped

  load_and_authorize_resource

  before_action { @project ||= @source.project }

  before_action only: :show do
    redirect_to project_source_url(@project, @source) unless params[:project_id].present?
  end

  def index
    @search_params = search_params
    @sources = Source.by_search_params(@search_params).by_project(@project)
  end

  def new
    @source = Source.new
  end

  def edit
    @source = Source.by_project(@project).find params[:id]
  end

  def show
    @source = Source.by_project(@project).find params[:id]
    authorize! :read, @source
    @star = @source.star_by current_user
    @review = @source.review_by(current_user) || Review.new(user: current_user, source: @source)
    @reviews = @source.reviews
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
      redirect_to project_sources_url(@project)
    else
      render 'new'
    end
  end

  def update
    @source = Source.by_project(@project).find params[:id]
    authorize! :update, @source
    @source.update source_params
    if (@source.save)
      redirect_to project_source_url(@project, @source)
    else
      render 'edits'
    end
  end

  def destroy
    @source = Source.by_project(@project).find params[:id]
    authorize! :destroy, @source
    if @source.destroy
      flash[:success] = 'Source removed succesfully!'
      redirect_to project_sources_url(@project)
    else
      flash[:danger] = 'Could not delete Source...'
      redirect_to project_source_url(@project, @source)
    end
  end

  protected
  def source_params
    prms = params.require(:source).permit(
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
      :note,
      :tag_ids
    )
    prms[:tag_ids] = prms[:tag_ids].split(',')
    prms[:project] = @project
    prms
  end

end
