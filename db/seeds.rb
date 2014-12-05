# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.find_or_create(first_name: "Tom", last_name: "Tom", email: "tom@e.com", password: "password")
Fabricate.times(4, :user)

%w(HTML CSS Angular.js Ruby Rails jQuery SQL Java Python).each do |language|
  Language.find_or_create(name: language, image_url: "#{language.downcase}.jpg")
end