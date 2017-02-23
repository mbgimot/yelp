require 'rails_helper'

RSpec.describe Restaurant, type: :model do

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    @user = User.create(email: "test@test.com", password: "testtest", password_confirmation: "testtest")
    @user.restaurants.create(name: 'The Scarecrow')
    restaurant = Restaurant.new(name: 'The Scarecrow')
    expect(restaurant).to have(1).error_on(:name)
  end

  it {should belong_to(:user)}
end

describe 'reviews' do
  describe 'build_with_user' do
    let(:user) { User.create email: 'test@test.com' }
    let(:restaurant) { Restaurant.create name: 'Test' }
    let(:review_params) { {rating: 5, thoughts: 'yum'} }
    subject(:review) { restaurant.reviews.build_with_user(review_params, user) }

    it 'builds a review' do
      expect(review).to be_a Review
    end

    it 'associated with the specified user' do
      expect(review.user).to eq user
    end
  end
end
