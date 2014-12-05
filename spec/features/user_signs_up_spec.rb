require 'spec_helper'

feature "user signs up" do

  scenario "successfull sign up" do
    visit sign_up_path
    expect(page).to have_content "Sign Up"
    expect(page).not_to have_selector "nav"

    fill_in "First name", with: "Alice"
    fill_in "Last name",  with: "from Wonderland"
    fill_in "Email",      with: "alice.wonder@exmaple.com"
    fill_in "Password",   with: "password"

    click_on "Create Account"
    
    expect(page).to have_content "You have successfully signed up"
    expect(page).to have_content "Sign in"
  end

  scenario "unsuccessfull sign up" do
    visit sign_up_path

    fill_in "First name", with: "Alice"
    fill_in "Last name", with: ""
    fill_in "Email", with: "alice@example"
    fill_in "Password", with: ""
    
    click_on "Create Account"
    
    expect(page).not_to have_selector "nav"
    expect(page).not_to have_content "You have successfully signed up"
    expect(page).to have_content "Last name can't be blank"
    expect(page).to have_content "Invalid email"
    expect(page).to have_content "Password can't be blank"
  end

end