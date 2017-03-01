class ApprovalsController < ApplicationController

  def create
    @approval = Approval.create approval_params
    if @approval.errors.any?
      flash[:error] = 'Failed to approve the source...'
    else
      flash[:success] = 'Source succesfully approved!'
    end
    if @approval.source.present?
      redirect_to source_url(@approval.source)
    else
      redirect_to sources_url
    end
  end

  def destroy
    @approval = Approval.find params[:id]
    @source = @approval.source
    if @approval.user == current_user && @approval.destroy
      flash[:success] = 'Approval succesfully removed!'
    else
      flash[:error] = "Removing approval failed!"
    end
    redirect_to source_url(@source)
  end

  protected
  def approval_params
    params.require(:approval).permit(:user_id, :source_id)
  end

end
