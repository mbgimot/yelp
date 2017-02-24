def leave_review(thoughts, rating)
  visit '/restaurants'
  click_link 'Review Los pollos hermanos'
  fill_in 'Thoughts', with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end
