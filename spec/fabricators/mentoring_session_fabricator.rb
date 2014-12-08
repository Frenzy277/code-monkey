Fabricator(:mentoring_session) do
  position { [1, 2, 3].sample }
  support { %w(mentoring code\ review).sample }
  mentee(fabricator: :user)
  skill
  mentor { |attrs| attrs[:skill].mentor }
end