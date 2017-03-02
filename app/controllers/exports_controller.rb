class ExportsController < ApplicationController

  def show
    @sources = Source.all
    @users = User.all
    disposition = params.key?(:download) ? 'attachment' : 'inline'
    respond_to do |format|
      format.pdf do
        render  pdf: 'export',
                template: 'exports/export',
                disposition: disposition
      end
    end
  end

end
