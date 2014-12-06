require 'spec_helper'

feature "user signs in" do
  given!(:alice) { Fabricate(:user) }
  
  scenario "with valid credentials" do
    visit sign_in_path
    expect(page).to have_content "Sign in"
    expect(page).not_to have_selector "nav"

    fill_in "Email", with: alice.email
    fill_in "Password", with: alice.password
    click_on "Sign in"

    expect(page).to have_content "You have logged in."
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content "Welcome to DevPledge, #{alice.first_name}"
    expect(page).not_to have_content "Sign in"
    expect(page).to have_content "Sign out"
  end

  scenario "with invalid credentials" do
    visit sign_in_path
    
    fill_in "Email", with: "no match"
    fill_in "Password", with: alice.password
    click_on "Sign in"

    expect(page).to have_content "Invalid email or password."
  end

end