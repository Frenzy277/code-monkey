require 'spec_helper'

feature "user interacts with navigation bar" do
  background { sign_in }

  scenario "user checks navigation links" do
    expect_to_see_all_navigation_links

    visit new_skill_path
    click_on "Dashboard"
    expect_to_be_on_dashboard_path
  end
end

def expect_to_see_all_navigation_links
  within("//nav[@role='navigation']") do 
    find_link("Credit: 1 hour").visible?
    find_link("Dashboard").visible?
    find_link("Arranged Queue").visible?
    find_link("Account").visible?
    find_link("Sign out").visible?
  end
end

def expect_to_be_on_dashboard_path
  expect(current_path).to eq(dashboard_path)
end