require 'spec_helper'

feature "front page content" do
  given!(:html)  { Fabricate(:language, name: "HTML") }
  given!(:css)   { Fabricate(:language, name: "CSS") }
  given!(:rails) { Fabricate(:language, name: "Rails") }
  background { visit root_path }

  scenario "has logo" do
    expect_to_see("{ dev: pledge }")
  end

  scenario "has working sign up link" do
    click_on "Sign up"
    expect_to_be_in(sign_up_url)
  end

  scenario "has working sign in link" do
    click_on "Sign in"
    expect_to_be_in(sign_in_url)
  end

  scenario "visitor interacts with language links" do
    within(:css, '.languages') do
      click_on "HTML"
      expect_to_be_in(language_url(html))
    end
  end

end