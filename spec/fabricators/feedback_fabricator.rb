Fabricator(:feedback) do
  giver(fabricator: :user)
  content { Faker::Lorem.paragraph([1, 2, 3].sample) }
  recommended { "true" }
end