class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user(review_params, current_user)
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
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user.id == Review.find(params[:id]).user_id
      @review = Review.find(params[:id])
      @review.destroy
      flash[:notice] = 'Review deleted succesfully'
    else
      flash[:alert] = 'Cannot delete'
    end
    redirect_to restaurant_path(@restaurant.id)
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
