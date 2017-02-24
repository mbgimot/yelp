require 'rails_helper'
require_relative '../helpers/restaurants_helper'

feature 'restaurants' do

  before do
    signup_user1
    @user = User.find_by_email("test@example.com")
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit('/restaurants')
      expect(page).to have_content('No restaurants yet')
      expect(page).to have_link('Add a restaurant')
    end
  end

  context 'restaurants have been added' do
    before do
      @user.restaurants.create(name: 'KFC', description: 'beautiful')
    end

    scenario 'display restaurants' do
      visit('/restaurants')
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit('/restaurants')
      click_link('Add a restaurant')
      fill_in 'Name', with: 'KFC'
      click_button('Create Restaurant')
      expect(page).to have_content('KFC')
      expect(current_path).to eq('/restaurants')
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_content('kf')
        expect(page).to have_content('error')
      end
    end

    context 'user not logged in' do
      scenario 'does not let you create a restaurant' do
        visit '/restaurants'
        click_link 'Sign out'
        click_link 'Add a restaurant'
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end


  end

  context 'viewing restaurants' do
    let!(:kfc) { @user.restaurants.create(name: 'KFC', description: 'beautiful')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link('KFC')
      expect(page).to have_content('KFC')
      expect(page).to have_content('beautiful')
      expect(current_path).to eq("/restaurants/#{kfc.id}")
    end
  end

  context 'editing restaurants' do
    before { @user.restaurants.create(name: 'KFC', description: 'beautiful', id: 1)}

    scenario 'let a user who created the restaurant, edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button('Update Restaurant')
      click_link('Kentucky Fried Chicken')
      expect(page).to have_content('Kentucky Fried Chicken')
      expect(page).to have_content('Deep fried goodness')
      expect(current_path).to eq('/restaurants/1')
    end

    scenario 'let a user who did not create a restaurant, not to edit a restaurant' do
      visit '/restaurants'
      click_link 'Sign out'
      signup_user2
      click_link 'Edit KFC'
      expect(page).to have_content('Cannot edit')
      expect(current_path).to eq('/restaurants')
    end
  end

  context 'deleting restaurants' do
    before { @user.restaurants.create(name: 'KFC', description: 'beautiful')}

    scenario 'let a user who created the restaurant, remove a restaurant when a user clicks delete' do
      visit('/restaurants')
      click_link 'Delete KFC'
      expect(page).not_to have_content('KFC')
      expect(page).to have_content("Restaurant deleted succesfully")
    end

    scenario 'let a user who did not create the restaurant, to not remove a restaurant when a user clicks delete' do
      visit('/restaurants')
      click_link 'Sign out'
      signup_user2
      click_link 'Delete KFC'
      expect(page).to have_content('Cannot delete')
      expect(current_path).to eq('/restaurants')
    end
  end


end
