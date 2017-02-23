class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find params[:restaurant_id]
    @review = @restaurant.build_review review_params, current_user

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])

    if @review.user == current_user
      @review.destroy
      redirect_to restaurant_path(Restaurant.find(params[:restaurant_id])), alert: 'You have deleted your review'
    else
      redirect_to restaurant_path(Restaurant.find(params[:restaurant_id])), alert: 'You can\'t delete other people\'s reviews, yo'
    end
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
