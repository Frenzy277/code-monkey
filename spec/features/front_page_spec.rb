require 'spec_helper'

feature "front page content" do
  given!(:html)  { Fabricate(:language, name: "HTML") }
  given!(:css)   { Fabricate(:language, name: "CSS") }
  given!(:rails) { Fabricate(:language, name: "Rails") }
  background { visit root_path }

  scenario "has logo" do
    expect(page).to have_content "{ dev: pledge }"
  end

  scenario "has working sign up link" do
    click_on "Sign up"
    expect(current_path).to eq(sign_up_path)
  end

  scenario "has working sign in link" do
    click_on "Sign in"
    expect(current_path).to eq(sign_in_path)
  end

  scenario "visitor interacts with language links" do

    within(:css, '.languages') do
      click_on "HTML"
      expect(current_path).to eq(language_path(html))
    end

  end

end