require 'spec_helper'

feature "user checks mentors profile" do
  
  scenario "user examines language show and clicks on mentors profile" do
    bob = Fabricate(:user)
    html = Fabricate(:language)
    skill = Fabricate(:skill, language: html, mentor: bob)
    sign_in
    
    click_on_language(html)
    expect_to_see bob.full_name
    click_link bob.full_name
    expect_url(user_url(bob))

    expect_to_see(bob.full_name)
    expect_to_see(bob.about_me)

    within_mentors_badge(skill) do
      expect_to_see(skill.experience.year)
      expect_to_see_link "Recommendations:"
      expect_to_see("Code helped in: 0 projects")
      expect(page).to have_css("span.badge", text: "0")
      expect_to_see_link "Mentoring"
      expect_to_see_link "Code Review"
    end

  end
end


def within_mentors_badge(skill, &block)
  within(:xpath, "//div[@id='mentor-skill-#{skill.id}']") do
    yield
  end
end

def expect_to_see(text)
  expect(page).to have_content text
end

def expect_to_see_link(link_text)
  expect(page).to have_link link_text
end

def click_on_language(language)
  find(:xpath, "//a[@href='/languages/#{language.id}']").click
end