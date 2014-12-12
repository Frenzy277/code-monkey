require 'spec_helper'
require 'database_cleaner'

feature "mentee interacts with dashboard" do
  given!(:html) { Fabricate(:language, name: "HTML") }
  given!(:css)  { Fabricate(:language, name: "CSS") }
  given(:alice) { Fabricate(:user) }
  given(:bob) { Fabricate(:user) }
  given(:dan) { Fabricate(:user) }

  scenario "mentee interacts with mentoring sessions from dashboard", :slow, js: true do
    Fabricate.times(2, :skill, language: html)
    Fabricate.times(2, :skill, language: css)
    Fabricate(:skill, language: html, mentor: bob)
    Fabricate(:skill, language: css, mentor: dan)
    Fabricate(:mentoring_session, mentee: alice, mentor: bob, position: nil, status: "completed")
    sign_in(alice)

    expect_big_link_to_language(html)
    expect_big_link_to_language(css)
    expect_language_mentors_number(html, 3)
    expect_language_mentors_number(css, 3)

    click_on html.name
    click_on_mentor_for(bob, "Mentoring")
    expect_to_see_table_with(bob.short_name, "HTML")
    
    click_on css.name
    click_on_mentor_for(dan, "Code Review")
    expect_to_see_table_with(dan.short_name, "CSS")
    
    click_feedback_link
    expect_to_see_modal_feedback_form
  end

  scenario "mentee clicks on feedback but has javascript turned off", :slow do
    ms = Fabricate(:mentoring_session, mentee: alice, mentor: bob, position: nil, status: "completed")
    sign_in(alice)
    
    click_feedback_link
    expect_url(new_mentoring_session_feedback_url(ms))
  end
end

def click_on_mentor_for(mentor, support)
  within(:xpath, "//div[@id='mentor_#{mentor.id}']") do
    click_on support
  end
end

def click_feedback_link
  within(:xpath, "//tr[contains(.,'completed')]") do
    click_link("feedback")
  end
end

def expect_to_see_table_with(mentor_short_name, language_name)
  within(:xpath, "//tbody") do
    expect(page).to have_content language_name
    expect(page).to have_content "pending"
    expect(page).to have_content "waiting on"
    expect(page).to have_content mentor_short_name
  end
end

def expect_big_link_to_language(language)
  expect(find(:xpath, "//a[@href='/languages/#{language.id}']//h4").text).to eq(language.name)
end

def expect_language_mentors_number(language, number)
  expect(find(:xpath, "//a[@href='/languages/#{language.id}']//span").text).to eq(number.to_s)
end

def expect_to_see_modal_feedback_form
  expect(page).to have_css('.modal#feedbackFormModal')
end