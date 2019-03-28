class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :determine_layout


  protected

  def after_sign_in_path(user)
    project = user.projects.most_recently_used
    if project.present?
      project_sources_path(project)
    else
      projects_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name,
      :last_name
    ])
  end

  def determine_layout
    if devise_controller?
      "plain"
    else
      "application"
    end
  end
end
