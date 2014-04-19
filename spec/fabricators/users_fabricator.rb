Fabricator(:user) do
  email { Faker::Internet.email }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  password { 'password' }
  organization
  organization_administrator false
end  

Fabricator(:organization_administrator, from: :user) do
  organization_administrator true
end