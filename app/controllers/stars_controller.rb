class StarsController < ApplicationController

  def create
    @star = Star.create star_params
    if @star.errors.any?
      flash[:danger] = 'Failed to approve the source...'
    else
      flash[:success] = 'Source succesfully starred!'
    end
    if @star.source.present?
      redirect_to source_url(@star.source)
    else
      redirect_to sources_url
    end
  end

  def destroy
    @star = Star.find params[:id]
    @source = @star.source
    if @star.user == current_user && @star.destroy
      flash[:success] = 'Star succesfully removed!'
    else
      flash[:danger] = "Removing star failed!"
    end
    redirect_to source_url(@source)
  end

  protected
  def star_params
    prms = params.require(:star).permit(:user_id, :source_id)
    prms[:user_id] = current_user.id
    prms
  end

end
