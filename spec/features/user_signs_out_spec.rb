require 'spec_helper'

feature "user signs out" do
  
  scenario "sign out" do
    alice = Fabricate(:user)
    visit sign_in_path
    fill_in "Email",    with: alice.email
    fill_in "Password", with: alice.password
    click_on "Sign in"
    click_on "Sign out"
    
    expect(page).to have_content "You have logged out."
    expect(current_path).to eq(root_path)
    expect(page).to_not have_content "Sign out"
  end

end