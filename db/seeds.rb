tom = Fabricate(:user, first_name: "Tom", last_name: "Tom", email: "tom@email.com", password: "password")
john  = Fabricate(:user, first_name: "John", last_name: "Doe", email: "john@email.com")
chris = Fabricate(:user, first_name: "Chris", last_name: "Hoe", email: "chris@email.com")
dana  = Fabricate(:user, first_name: "Dana", last_name: "Woe", email: "DANA@email.com")

%w(HTML CSS Angular.js Ruby Rails jQuery SQL Python).each do |language|
  Language.find_or_create_by(name: language, image_url: "#{language.downcase}.jpg")
end

Fabricate(:skill, mentor: tom, language: Language.first)
Fabricate(:skill, mentor: john, language: Language.first)
Fabricate(:skill, mentor: chris, language: Language.first)
Fabricate(:skill, mentor: dana, language: Language.first)
