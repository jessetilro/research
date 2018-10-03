module ProjectScoped
  extend ActiveSupport::Concern

  included do
    before_action :load_project
  end

  protected
  def load_project
    @projects = current_user.projects
    @project = params[:project_id].present? ? @projects.find(params[:project_id]) : @projects.first
    # TODO make this more efficient
    @participation = @project.participations.find_by(user: current_user)
    @participation.touch :last_used_at
    authorize! :read, ([@project] + @projects)
  end

end
