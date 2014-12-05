Fabricator(:user) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email do |attrs| 
    sequence(:email) do |n| 
      "#{attrs[:first_name].parameterize}.#{attrs[:last_name]}#{n}@example.com"
    end
  end
  password "password"
end