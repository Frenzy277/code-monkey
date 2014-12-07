Fabricator(:queue_item) do
  position { [1, 2, 3].sample }
  support { %w(mentoring code\ review).sample }
  mentee(fabricator: :user)
  mentor(fabricator: :user)
  skill
end