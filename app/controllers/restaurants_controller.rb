class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @restaurants = Restaurant.all
    @user = current_user
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @user = current_user
    @restaurant = @user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @user = current_user
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    if current_user.id == Restaurant.find(params[:id]).user_id
      @restaurant = Restaurant.find(params[:id])
    else
      flash[:alert] = 'Cannot edit'
      redirect_to restaurants_path
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    if current_user.id == Restaurant.find(params[:id]).user_id
      @restaurant = Restaurant.find(params[:id])
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted succesfully'
      redirect_to '/restaurants'
    else
      flash[:alert] = 'Cannot delete'
      redirect_to restaurants_path
    end
  end


  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description)
  end

end
