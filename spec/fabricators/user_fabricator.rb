Fabricator(:user) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email { |attrs| "#{attrs[:first_name].parameterize}.#{attrs[:last_name]}@example.com" }
  password "password"
end