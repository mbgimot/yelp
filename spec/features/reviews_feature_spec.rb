require 'rails_helper'
require_relative '../helpers/restaurants_helper_spec'

feature 'Users can review restaurants' do
  before do
    signup_user1
    @user = User.find_by_email('test@example.com')
    @user.restaurants.create(name: 'Los pollos hermanos', description: 'beautiful')
  end

  scenario 'by creating a review via a form' do
    visit '/restaurants'
    click_link 'Review Los pollos hermanos'
    fill_in 'Thoughts', with: 'Although serving chicken, it is fishy'
    select '1', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'Although serving chicken, it is fishy'
  end

  scenario 'users can delete their own reviews' do
    visit '/restaurants'
    click_link 'Review Los pollos hermanos'
    fill_in 'Thoughts', with: 'Although serving chicken, it is fishy'
    select '1', from: 'Rating'
    click_button 'Leave Review'
    click_link('Los pollos hermanos')
    click_link('Delete review')
    expect(page).not_to have_content 'Although serving chicken, it is fishy'
  end

  scenario 'users cannot delete other users reviews' do
    visit '/restaurants'
    click_link 'Review Los pollos hermanos'
    fill_in 'Thoughts', with: 'Although serving chicken, it is fishy'
    select '1', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Sign out'
    signup_user2
    click_link('Los pollos hermanos')
    expect(page).not_to have_link 'Delete review'
  end
end
