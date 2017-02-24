require 'rails_helper'
require_relative '../helpers/restaurants_helper'
require_relative '../helpers/reviews_helper'

feature 'Users can review restaurants' do
  before do
    signup_user1
    @user = User.find_by_email('test@example.com')
    @user.restaurants.create(name: 'Los pollos hermanos', description: 'beautiful')
    visit '/restaurants'
  end

  scenario 'by creating a review via a form' do
    leave_review('Although serving chicken, it is fishy', '1')
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'Although serving chicken, it is fishy'
  end

  scenario 'users can delete their own reviews' do
    leave_review('Although serving chicken, it is fishy', '1')
    click_link('Los pollos hermanos')
    click_link('Delete review')
    expect(page).not_to have_content 'Although serving chicken, it is fishy'
  end

  scenario 'users cannot delete other users reviews' do
    leave_review('Although serving chicken, it is fishy', '1')
    click_link 'Sign out'
    signup_user2
    click_link('Los pollos hermanos')
    expect(page).not_to have_link 'Delete review'
  end

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    click_link 'Sign out'
    signup_user2
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end
end
