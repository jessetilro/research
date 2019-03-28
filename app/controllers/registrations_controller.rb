class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    welcome_path(params: { name: resource.first_name })
  end

  def after_inactive_sign_up_path_for(resource)
    welcome_path(params: { name: resource.first_name })
  end
end
