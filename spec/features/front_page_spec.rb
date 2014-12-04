require 'spec_helper'

feature "front page content" do
  background { visit root_path }
  
  scenario "has logo" do
    expect(page).to have_content "{ dev: pledge }"
  end

  scenario "has basic navigation links" do
    find_link('Sign in').visible?
    find_link('Sign up').visible?
  end

end