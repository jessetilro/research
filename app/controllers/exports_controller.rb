class ExportsController < ApplicationController
  include Searching
  include ProjectScoped

  def show
    @sources = Source.by_search_params(search_params).by_project(@project)
    @users = User.all
    disposition = params.key?(:download) ? 'attachment' : 'inline'
    respond_to do |format|
      format.pdf do
        render  pdf: 'export',
                template: 'exports/export',
                dpi: '300',
                margin: {top: 10, bottom: 10, left: 20, right: 20},
                user_xserver: false,
                disposition: disposition
      end
      format.bib do
        render plain: Source.to_bibliography(@sources).to_s
      end
    end
  end

end
