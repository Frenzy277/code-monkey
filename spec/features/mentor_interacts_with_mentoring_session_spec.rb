require 'spec_helper'

feature "mentor interacts with mentoring sessions" do
  given!(:bob) { Fabricate(:user) }
  background do
    sign_in(bob)
    becomes_a_mentor
  end

  scenario "mentor checks mentoring sessions" do
    click_link "Mentoring Sessions"
    expect_to_see('h1', "Mentoring Sessions")
    expect_url(mentoring_sessions_url)
  end
end

def expect_to_see(h, text)
  expect(page).to have_css(h, text: text)
end

def becomes_a_mentor
  language = Fabricate(:language)
  visit new_skill_path
  select(language.name, from: "Language")
  fill_in "Description", with: Faker::Lorem.paragraph(2)
  select("2010", from: "Experience")
  click_button "Sign the pledge"
end