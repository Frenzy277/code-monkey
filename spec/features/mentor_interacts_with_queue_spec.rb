require 'spec_helper'

feature "mentor interacts with arranged queue" do
  given!(:bob) { Fabricate(:user) }
  background do
    sign_in(bob)
    becomes_a_mentor
  end

  scenario "mentor checks arranged queue" do
    click_on "Arranged Queue"
    expect_to_see("Arrangements Queue")
    expect_right_url(mentor_queue_url)
  end

end

def expect_to_see(text)
  expect(page).to have_css('h1', text: text)
end

def expect_right_url(url)
  expect(current_url).to eq(url)
end

def becomes_a_mentor
  language = Fabricate(:language)
  visit new_skill_path
  select(language.name, from: "Language")
  fill_in "Description", with: Faker::Lorem.paragraph(2)
  select("2010", from: "Experience")
  click_button "Sign the pledge"
end