class ProjectsController < ApplicationController

  def index
    @projects = current_user.projects
    @project = @projects.first
    authorize! :read, @projects
  end

end
