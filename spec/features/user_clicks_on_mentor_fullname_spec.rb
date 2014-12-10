require 'spec_helper'

feature "user checks languages show" do
  given!(:brano) { Fabricate(:user, first_name: "Brano") }

  scenario "user clicks on mentor fullname link" do
    tom = Fabricate(:user, first_name: "Tom", last_name: "Tomecek")
    html = Fabricate(:language, name: "HTML")
    skill = Fabricate(:skill, language: html, mentor: tom)
    sign_in(brano)
    
    find(:xpath, "//a[@href='/languages/#{html.id}']").click

    expect(page).to have_content "Tom Tomecek"
    click_on "Tom Tomecek"
    expect(current_url).to eq(user_url(tom))
  end
end