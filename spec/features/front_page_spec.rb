require 'spec_helper'

feature "front page content" do
  background { visit root_path }
  
  scenario "has logo" do
    expect(page).to have_content "{ dev: pledge }"
  end

  scenario "has working sign up link" do
    click_on "Sign up"
    expect(current_path).to eq(sign_up_path)
  end

  scenario "has working sign in link" do
    click_on "Sign in"
    expect(current_path).to eq(sign_in_path)
  end

end