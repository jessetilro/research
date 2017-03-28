module ProjectScoped
  extend ActiveSupport::Concern

  included do
    before_action :load_project
  end

  protected
  def load_project
    @project = Project.find(params[:project_id] || params[:id])
    @projects = current_user.projects
  end

end
