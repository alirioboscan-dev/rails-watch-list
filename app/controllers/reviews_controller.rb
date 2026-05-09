class ReviewsController < ApplicationController
  def create
    @list = List.find(params[:list_id])
    @review = Review.new(review_params)
    @review.list = @list
    if @review.save
      redirect_to list_path(@list), notice: "Review added!"
    else
      @bookmark = Bookmark.new
      @movies = Movie.all
      render "lists/show", status: :unprocessable_entity
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @list = @review.list
    @review.destroy
    redirect_to list_path(@list), notice: "Review deleted."
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating)
  end
end
