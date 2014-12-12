require 'spec_helper'

feature "user checks recommendations" do
  scenario "user clicks on recommendations", :slow, js: true do
    alice = Fabricate(:user)
    doug  = Fabricate(:user)
    bob   = Fabricate(:user)
    html  = Fabricate(:language)
    skill = Fabricate(:skill, language: html, mentor: bob)
    ms1   = Fabricate(:mentoring_session, skill: skill, mentor: bob, mentee: alice)
    ms2   = Fabricate(:mentoring_session, skill: skill, mentor: bob, mentee: doug)
    positive_feedback = Fabricate(:feedback, mentoring_session: ms1, recommended: true, content: "Good job!", giver: alice, created_at: 1.day.ago)
    negative_feedback = Fabricate(:feedback, mentoring_session: ms2, recommended: false, content: "Weak", giver: doug)
    
    sign_in
    visit language_path(html)

    within_badge_of bob do
      expect_to_see_recommendations_count(2)
      click_on_recommendations_on(skill)
    end

    expect_to_see_feedback_modal

    within_feedback_modal do
      expect_to_see_icon("bullhorn")
      expect_to_see_mentors_full_name(bob)

      within_feedback positive_feedback do
        expect_to_see_mentees_photo
        expect_to_see_language_name(html)
        expect_to_see_content(positive_feedback)
        expect_to_see_icon("thumbs-up")
        expect_link_to_giver(alice)
        expect_to_see_creation_date(positive_feedback)
      end      

      within_feedback negative_feedback do
        expect_to_see_icon("thumbs-down")
      end

      click_button "Close"
    end

    expect_modal_to_disappear
  end
end

def within_badge_of(mentor, &block)
  within("#mentor_#{mentor.id}") do
    yield
  end
end

def expect_to_see_recommendations_count(number)
  expect(find(:css, ".recommendations > span.badge").text).to eq(number.to_s)
end

def click_on_recommendations_on(skill)
  find(:xpath, "//a[@href='/skills/#{skill.id}/feedbacks']").click
end

def within_feedback_modal(&block)
  within(".modal") do
    yield
  end
end

def within_feedback(feedback, &block)
  within("#feedback_#{feedback.id}") do
    yield
  end
end

def expect_to_see_mentors_full_name(mentor)
  expect(page).to have_content "Feedback: #{mentor.full_name}"
end

def expect_to_see_feedback_modal
  expect(page).to have_css(".modal")
end

def expect_to_see_icon(icon_type)
  expect(page).to have_css(".glyphicon-#{icon_type}")
end

def expect_to_see_language_name(language)
  expect(page).to have_css(".feedback-language", text: language.name)
end

def expect_to_see_mentees_photo
  expect(page).to have_css(".modal-feedback-photo")
end

def expect_link_to_giver(giver)
  find_link("#{giver.short_name}").visible?
end

def expect_to_see_content(feedback)
  expect(page).to have_css(".user-feedback", text: feedback.content)
end

def expect_to_see_creation_date(feedback)
  expect(page).to have_content feedback.created_at.strftime("%m/%d/%Y")
end

def expect_modal_to_disappear
  expect(page).to have_no_css(".modal")
end
