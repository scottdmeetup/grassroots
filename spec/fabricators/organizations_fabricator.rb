Fabricator(:organization) do
  name { Faker::Company.name }
  mission_statement { Faker::Company.catch_phrase }
  ein { Faker::Code.isbn }
  street1 { Faker::Address.street_address }
  city { Faker::Address.city }
  state_id { Faker::Address.state_abbr }
  zip { Faker::Address.zip_code }
  ntee_major_category_id { Faker::Commerce.department }
end