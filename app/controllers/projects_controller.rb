class ProjectsController < ApplicationController

  load_and_authorize_resource

  before_action do
    @projects = current_user.projects
    @project ||= @projects.first
    authorize! :read, @projects
  end

  def index
  end

  def show
    render 'index'
  end

end
