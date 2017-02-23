require 'rails_helper'

feature 'Users can review restaurants' do
  before do
    @user = User.create(email: "test@test.com", password: "testtest", password_confirmation: "testtest")
    @user.restaurants.create(name: 'Los pollos hermanos', description: 'beautiful')
  end

  scenario 'by creating a review via a form' do
    visit('/')
    click_link('Sign in')
    fill_in('Email', with: 'test@test.com')
    fill_in('Password', with: 'testtest')
    click_button('Log in')
    click_link 'Review Los pollos hermanos'
    fill_in 'Thoughts', with: 'Although serving chicken, it is fishy'
    select '1', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'Although serving chicken, it is fishy'
  end
end
