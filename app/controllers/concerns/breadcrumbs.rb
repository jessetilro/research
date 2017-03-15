module Breadcrumbs
  extend ActiveSupport::Concern

  included do
    before_action :set_breadcrumbs
    before_action :add_breadcrumbs_new, only: :new
    before_action :add_breadcrumbs_show, only: [:show, :edit]
    before_action :add_breadcrumbs_edit, only: :edit
    before_action :finalize_breadcrumbs
  end

  protected
  def set_breadcrumbs
    @breadcrumbs = [{ model.model_name.human(count: 2) => url_for(model) }]
  end

  def add_breadcrumbs_new
    @breadcrumbs.push({ "New" => url_for(action: :new, controller: controller_name) })
  end

  def add_breadcrumbs_show
    @breadcrumbs.push({ "#{model.model_name.human} #{params[:id]}" => url_for(model.find(params[:id])) })
  end

  def add_breadcrumbs_edit
    @breadcrumbs.push({ "Edit" => url_for(action: :edit, controller: controller_name) })
  end

  def finalize_breadcrumbs
    @breadcrumbs[@breadcrumbs.size - 1] = { @breadcrumbs.last.first.first => :active }
  end

  def model
    controller_name.classify.constantize
  end

end
