Fabricator(:project) do
  description  { Faker::Lorem.paragraph }
  skills { ["Grant Writing", "Web Development", "Graphic Design", "Business Planning", "Accounting"].sample}
  deadline { Date.today + 1.month }
  estimated_hours {20}
end