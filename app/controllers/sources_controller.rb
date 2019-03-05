class SourcesController < ApplicationController
  include Searching
  include ProjectScoped

  load_and_authorize_resource

  before_action { @project ||= @source.project }
  before_action(only: [:index, :new, :edit]) { @tags = @project.tags }

  before_action only: :show do
    redirect_to project_source_url(@project, @source) unless params[:project_id].present?
  end

  before_action do
    add_breadcrumb "#{Source.model_name.human(count: 2)}", project_sources_url(@project)
  end

  before_action only: [:show, :edit] do
    add_breadcrumb "#{Source.model_name.human} #{@source.id}", project_source_url(@project, @source)
  end

  def index
    @search_params = search_params
    @sources = Source.by_search_params(@search_params).by_project(@project)
        .includes(stars: :user)
        .includes(:tags)
        .includes(:reviews)
        .select(Source.arel_table[Arel.star])
        .select_average_rating
  end

  def new
    @source = Source.new
    add_breadcrumb "New #{Source.model_name.human}"
  end

  def edit
    @source = Source.by_project(@project).find params[:id]
    add_breadcrumb 'Edit'
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
        path = ActiveStorage::Blob.service.send(:path_for, @source.document.key)
        send_file File.realpath(path),
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
    if @source.update source_params
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
      :bibtex_key,
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
      :tag_ids,
      :bibtex_text,
      :reference_text
    )
    prms[:tag_ids] = prms[:tag_ids].split(',') if prms[:tag_ids].present?
    prms[:project] = @project
    prms
  end

  def index_breadcrumb_path
    project_sources_path(@project)
  end

end
