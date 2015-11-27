require 'rails_helper'

feature 'reviewing' do
  before { Restaurant.create name: 'KFC' }

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'it deletes a review when the parent restaurant is destroyed' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "This is amazing"
    select '5', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Delete KFC'
    expect(page).not_to have_content('This is amazing')
  end

  def leave_review(thoughts, rating)
    visit '/restaurants'
    click_link('Review KFC')
    fill_in('Thoughts', with: thoughts)
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    signup_signin
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end


end
