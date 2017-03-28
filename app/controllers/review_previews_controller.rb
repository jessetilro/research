class ReviewPreviewsController < ApplicationController
  include ProjectScoped

  def index
    @review = Review.new review_params
    respond_to do |format|
      format.js
    end
  end

  protected
  def review_params
    params.require(:review).permit(:comment)
  end

end
