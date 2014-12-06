Fabricator(:user) do
  first_name "John"
  last_name "Doe"
  email { sequence(:email) { |n| "john.doe.#{n}@example.com" } }
  password "password"
end