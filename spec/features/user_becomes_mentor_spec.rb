require 'spec_helper'

feature "user wants to be a mentor" do
  given!(:alice) { Fabricate(:user) }
  given!(:rails) { Fabricate(:language) }

  scenario "becomes the mentor" do
    sign_in(alice)
    click_on_language(rails)

    expect_to_see("#{rails.name} Mentors")

    click_on "Become a Mentor"
    expect_to_see("Mentor next generation")

    fill_in_and_submit_form(rails)

    verify_flash_message
    verify_dashboard_path
  end
end

def click_on_language(language)
  find(:xpath, "//a[@href='/languages/#{language.id}']").click
end

def expect_to_see(content)
  expect(page).to have_content content
end

def fill_in_and_submit_form(language)
  select(language.name, from: "Skill")
  fill_in "Description", with: Faker::Lorem.paragraph(2)
  select("2010", from: "Experience")
  click_button "Sign the pledge"
end

def verify_flash_message
  expect(page).to have_content "Congratulations, you became a new mentor"
end

def verify_dashboard_path
  expect(current_path).to eq(dashboard_path)
end