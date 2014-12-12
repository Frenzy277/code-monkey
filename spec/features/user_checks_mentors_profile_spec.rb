require 'spec_helper'

feature "user checks mentors profile" do
  
  scenario "user clicks on mentor fullname link" do
    john = Fabricate(:user, first_name: "John", last_name: "Doe")
    html = Fabricate(:language)
    skill = Fabricate(:skill, language: html, mentor: john)
    sign_in
    
    click_on_language(html)
    expect_to_see "John Doe"
    click_on "John Doe"
    expect_url(user_url(john))
  end
end

def expect_to_see(text)
  expect(page).to have_content text
end

def click_on_language(language)
  find(:xpath, "//a[@href='/languages/#{language.id}']").click
end