class ExportsController < ApplicationController

  def show
    @sources = Source.all
    @users = User.all
    respond_to do |format|
      format.pdf do
        render  pdf: 'export',
                template: 'exports/export',
                disposition: 'attachment'
      end
    end
  end

end
