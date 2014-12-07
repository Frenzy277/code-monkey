require 'spec_helper'

feature "mentee adds items to queue" do
  given!(:alice) { Fabricate(:user) }
  given!(:bob)   { Fabricate(:user) }
  given!(:html)  { Fabricate(:language) }
  given!(:skill) { Fabricate(:skill, language: html, mentor: bob) }

  background do
    sign_in(alice)
    visit language_path(html)
  end

  scenario "mentee selects mentoring" do
    clicks_on(bob, "Mentoring")

    expect_to_see_success_flash_message(bob, "mentoring")
    expect_right_url(dashboard_url)
  end

  scenario "mentee selects code review" do
    clicks_on(bob, "Code Review")

    expect_to_see_success_flash_message(bob, "code review")
    expect_right_url(dashboard_url)
  end

end

def clicks_on(mentor, attribute)
  within(:xpath, "//div[@id='mentor_#{mentor.id}']") do
    click_on attribute
  end
end

def expect_to_see_success_flash_message(mentor, subject)
  expect(find(:css, '.alert').text).to have_content "Great, you have signed up for #{subject} from #{mentor.full_name}. Check your dashboard 'Signed for' table for status."
end

def expect_right_url(url)
  expect(current_url).to eq(url)
end