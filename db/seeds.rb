Fabricate(:user, first_name: "Tom", last_name: "Tom", email: "tom@email.com", password: "password")
4.times { Fabricate(:user) }

%w(HTML CSS Angular.js Ruby Rails jQuery SQL Java Python).each do |language|
  Language.find_or_create_by(name: language, image_url: "#{language.downcase}.jpg")
end