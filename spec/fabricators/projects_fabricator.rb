Fabricator(:project) do
  description  { Faker::Lorem.paragraph }
  deadline { Date.today + 1.month }
  estimated_hours {20}
end