class ExportsController < ApplicationController

  def show
    @sources = Source.all
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
    end
  end

end
