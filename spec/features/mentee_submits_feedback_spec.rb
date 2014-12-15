require 'spec_helper'

feature "mentee submits feedback" do
  given!(:alice) { Fabricate(:user) }
  given!(:ms) do
    Fabricate(:mentoring_session, mentee: alice, position: nil, status: "completed")
  end
  
  background do
    sign_in(alice)
    click_feedback_link
  end

  scenario "with AJAX and modal", :slow, js: true do
    fill_in_feedback_form 'with_javascript' do
      expect_to_see "Feedback on Mentoring Session with"
      submit_invalid_data
      expect_to_see "Feedback can't be blank"
      submit_valid_data
    end

    expect_to_not_see "Submit Feedback"
    expect_modal_to_be_gone
    within_sign_for_table(ms) do
      expect_to_see "submitted"
    end
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
    within_sign_for_table(ms) do
      expect_to_see "submitted"
    end
  end
end

def click_feedback_link
  within(:xpath, "//tr[contains(.,'completed')]") do
    click_link("feedback")
  end
end

def fill_in_feedback_form(with_js_option = nil, &block)
  if with_js_option
    within(:css, ".modal") { yield }
  else
    yield
  end
end

def expect_modal_to_be_gone
  expect(page).to have_no_css(".modal")
end

def within_sign_for_table(ms, &block)
  within(:xpath, "//td[@id='feedback_ms_#{ms.id}']") do
    yield
  end
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