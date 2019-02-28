class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected

  def after_sign_in_path(user)
    project = user.projects.most_recently_used
    project_sources_path(project)
  end
end
