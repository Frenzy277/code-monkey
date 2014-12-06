require 'spec_helper'

feature "user wants to be a mentor" do
  scenario "becomes the mentor" do
    alice = Fabricate(:user)
    rails = Fabricate(:language)
    sign_in(alice)
    click_on_language(rails)

    expect(page).to have_content "#{rails.name} Mentors"

    click_on "Become a Mentor"
    expect(current_path).to eq(new_skill_path)
  end
end

def click_on_language(language)
  find(:xpath, "//a[@href='/languages/#{language.id}']").click
end