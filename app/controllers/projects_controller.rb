class ProjectsController < ApplicationController

  load_and_authorize_resource

  before_action do
    @projects = current_user.projects
    @project ||= @projects.first
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
