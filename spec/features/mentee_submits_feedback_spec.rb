require 'spec_helper'

feature "mentee submits feedback" do
  given!(:alice) { Fabricate(:user) }
  given!(:ms) { Fabricate(:mentoring_session, mentee: alice, position: nil, status: "completed") }
  background do
   sign_in(alice)
   click_feedback_link
  end

  scenario "with AJAX and modal", js: true do
    fill_in_feedback_form 'with_javascript' do
      expect_to_see "Feedback on Mentoring Session with"
      submit_invalid_data
      expect_to_see "Feedback can't be blank"
      submit_valid_data
    end

    expect_to_not_see "Submit Feedback"
    expect(page).to have_no_css(".modal")
    expect_to_see_mentoring_session_feedback_submitted(ms)
  end

  scenario "with javascript turned off" do
    fill_in_feedback_form do
      expect_to_see "Feedback form"
      submit_invalid_data
      expect_to_see "Content can't be blank"
      submit_valid_data
    end

    expect_url(dashboard_url)
    expect_to_see("Thank you for submitting the feedback")
    expect_to_see_mentoring_session_feedback_submitted(ms)
  end
end

def click_feedback_link
  within(:xpath, "//tr[contains(.,'completed')]") do
    click_link("feedback")
  end
end

def fill_in_feedback_form(with_js_option = nil, &block)
  if with_js_option
    within(:css, ".modal") do
      yield
    end
  else
    yield
  end
end

def expect_to_see_mentoring_session_feedback_submitted(ms)
  within(:xpath, "//td[@id='feedback_ms_#{ms.id}']") do
    expect(page).to have_content "submitted"
  end
end

def expect_to_see(text)
  expect(page).to have_content text
end

def expect_to_not_see(text)
  expect(page).to have_no_content text
end

def submit_invalid_data
  fill_in "Feedback form:", with: ""
  click_button "Submit Feedback"
end

def submit_valid_data
  uncheck "Recommend ?"
  fill_in "Feedback form:", with: "You should shape up!"
  click_button "Submit Feedback"
end