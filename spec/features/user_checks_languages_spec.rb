require 'spec_helper'

feature "user checks languages from front page" do

  scenario "user clicks on a language" do
    html = Fabricate(:language, name: "HTML")
    
    visit root_url
    find_link("HTML").click
    expect_url(language_url(html))
  end
end