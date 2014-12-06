require 'spec_helper'

feature "user interacts with dashboard" do
  given!(:html) { Fabricate(:language) }
  given!(:css)  { Fabricate(:language) }
  given!(:ruby) { Fabricate(:language) }

  scenario "user sees multiple languages" do
    sign_in

    expect_big_link_to_language(html)
    expect_big_link_to_language(css)
    expect_big_link_to_language(ruby)    
  end

  scenario "user sees number of mentors under different languages" do
    Fabricate.times(2, :skill, language: html)
    Fabricate.times(3, :skill, language: css)
    Fabricate.times(9, :skill, language: ruby)
    sign_in

    expect_language_mentors_number(html, 2)
    expect_language_mentors_number(css, 3)
    expect_language_mentors_number(ruby, 9)
  end

end

def expect_big_link_to_language(language)
  expect(find(:xpath, "//a[@href='/languages/#{language.id}']//h4").text).to eq(language.name)
end

def expect_language_mentors_number(language, number)
  expect(find(:xpath, "//a[@href='/languages/#{language.id}']//span").text).to eq(number.to_s)
end