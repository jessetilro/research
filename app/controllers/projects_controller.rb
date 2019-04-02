class ProjectsController < ApplicationController

  load_and_authorize_resource

  before_action do
    @participations = current_user.participations.ordered_by_last_usage.includes(:project)
    @projects = @participations.map(&:project)
    @other_projects = Project.where.not(id: @participations.select(:project_id)).order(created_at: :desc)
    @project ||= @participations.first.try(:project)
    @source_counts = Source.unscoped.group(:project_id).count
    @new_project = Project.new
    authorize! :read, @projects
  end

  def index
    render_view
  end

  def show
    render_view
  end

  def new
    @project = @new_project
    render 'new'
  end

  def create
    @new_project = Project.new(project_params)
    @new_project.participations.new(user: current_user)

    if @new_project.save
      redirect_to project_sources_path(@new_project)
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
    authorize! :edit, @project
    render 'edit'
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to projects_url, notice: "Succesfully updated '#{@project.name}' project"
    else
      render 'edit'
    end
  end

  protected

  def render_view
    if @projects.present?
      render 'index'
    else
      render 'new'
    end
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
