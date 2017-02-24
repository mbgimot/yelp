require 'rails_helper'

RSpec.describe Restaurant, type: :model do

  before do
    @user = User.create(email: "test@test.com", password: "testtest", password_confirmation: "testtest")
  end

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    @user.restaurants.create(name: 'The Scarecrow')
    restaurant = Restaurant.new(name: 'The Scarecrow')
    expect(restaurant).to have(1).error_on(:name)
  end

  it {should belong_to(:user)}

end

describe '#average_rating' do
  before do
    @user = User.create(email: "test@test.com", password: "testtest", password_confirmation: "testtest")
  end

  context 'no reviews' do
    it 'returns "N/A" when there are no reviews' do
      restaurant = @user.restaurants.create(name: 'The Ivy')
      expect(restaurant.average_rating).to eq 'N/A'
    end
  end

  context '1 review' do
    it 'returns that rating' do
      @restaurant = @user.restaurants.create(name: 'The Ivy')
      @restaurant.reviews.create(rating: 4, user: @user)
      expect(@restaurant.average_rating).to eq 4
      end
    end

  context 'multiple reviews' do
    it 'returns the average' do
      @restaurant = @user.restaurants.create(name: 'The Ivy')
      @restaurant.reviews.create(rating: 1, user: @user)
      @user2 = User.create(email: "test1@test1.com", password: "testtest", password_confirmation: "testtest")
      @restaurant.reviews.create(rating: 5, user: @user2)
      expect(@restaurant.average_rating).to eq 3
    end
  end


end
