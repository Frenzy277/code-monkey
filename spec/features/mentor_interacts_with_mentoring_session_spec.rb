require 'spec_helper'

feature "mentor interacts with mentoring sessions" do
  given!(:bob) { Fabricate(:user) }
  given!(:alice) { Fabricate(:user) }
  given!(:skill) { Fabricate(:skill, mentor: bob) }
  background do
    sign_in(bob)
    becomes_a_mentor
  end

  scenario "mentor checks mentoring sessions", :slow do
    click_link "Mentoring Sessions"
    expect_to_see("There are no ongoing mentoring sessions")    

    ms = Fabricate(:mentoring_session, mentor: bob, mentee: alice, status: "pending", created_at: 1.hour.ago, skill: skill)
    click_link "Mentoring Sessions"
    
    within_table_row_of(ms) do
      expect(page).to have_content skill.language.name
      expect(page).to have_content ms.created_at
      expect(page).to have_link alice.full_name
      expect(page).to have_content "pending"
      select("accepted", from: "mentoring_sessions[][status]")
    end
    click_on "Update Sessions"

    within_table_row_of(ms) do
      expect(page).to have_content "accepted"
      click_link alice.full_name
    end

    expect_url(user_url(alice))
    click_link "Mentoring Sessions"

    within_table_row_of(ms) do
      select("completed", from: "mentoring_sessions[][status]")      
    end
    click_on "Update Sessions"

    expect_to_see("There are no ongoing mentoring sessions")
    within_navigation do
      expect(page).to have_content "Credit: 2 hours"
    end
  end
end

def within_table_row_of(ms, &block)
  within(:xpath, "//tbody//tr[@id='ms_#{ms.id}']") do
    yield
  end
end

def within_navigation(&block)
  within(:xpath, "//nav") do
    expect(page).to have_content "Credit: 2 hours"
  end
end

def expect_to_see(text)
  expect(page).to have_content text
end

def becomes_a_mentor
  language = Fabricate(:language)
  visit new_skill_path
  select(language.name, from: "Language")
  fill_in "Description", with: Faker::Lorem.paragraph(2)
  select("2010", from: "Experience")
  click_button "Sign the pledge"
end