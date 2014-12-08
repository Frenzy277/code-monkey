require 'spec_helper'

feature "user interacts with navigation bar" do
  background { sign_in }

  scenario "non-mentor checks navigation links" do
    expect_to_see_all_navigation_links_for("non-mentor")

    visit new_skill_path
    click_on "Dashboard"
    expect_url(dashboard_url)
  end

  scenario "mentor checks navigation links" do
    becomes_a_mentor
    expect_to_see_all_navigation_links_for("mentor")
  end
end

def expect_to_see_all_navigation_links_for(user)
  within("//nav[@role='navigation']") do 
    find_link("Credit: 1 hour").visible?
    find_link("Dashboard").visible?
    find_link("Account").visible?
    find_link("Sign out").visible?

    if user == "non-mentor"
      expect(page).to have_no_content "Mentoring Sessions"
    else
      find_link("Mentoring Sessions").visible?
    end
  end
end

def becomes_a_mentor
  language = Fabricate(:language)
  visit new_skill_path
  select(language.name, from: "Language")
  fill_in "Description", with: Faker::Lorem.paragraph(2)
  select("2010", from: "Experience")
  click_button "Sign the pledge"
end