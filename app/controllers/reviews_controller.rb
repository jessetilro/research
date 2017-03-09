class ReviewsController < ApplicationController

  def create
    review = Review.new review_params
    if review.save
      flash[:success] = 'Succefully saved your review for this source!'
      redirect_to source_url(review.source)
    else
      flash[:danger] = 'Failed to save your review for this source...'
      redirect_to (review.source.present? ? source_url(review.source) : sources_url)
    end
  end

  def update
    review = Review.find params[:id]
    if review.update(review_params)
      flash[:success] = 'Succefully updated your review for this source!'
      redirect_to source_url(review.source)
    else
      flash[:danger] = 'Failed to update your review for this source...'
      redirect_to (review.source.present? ? source_url(review.source) : sources_url)
    end
  end

  protected
  def review_params
    prms = params.require(:review).permit(
      :source_id,
      :comment,
      :rating
    )
    prms[:user_id] = current_user.id
    prms
  end

end
