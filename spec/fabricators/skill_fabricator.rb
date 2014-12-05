Fabricator(:skill) do
  mentor(fabricator: :user)
  language
  experience { "#{Array(2000..2014).sample}-01-01" }
end