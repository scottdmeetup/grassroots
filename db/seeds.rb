Organization.destroy_all
huggey_bears = Organization.create(name: "Huggey Bear Land", cause: "Animal Rights", ruling_year: 1998, 
  mission_statement: "We want to give everyone a huggey bear in their sad times", guidestar_membership: nil, 
  ein: "192512653-6", street1: "2998 Hansen Heights", street2: nil, city: "New York", 
  state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil,
  budget: "$22,000,000.00", contact_number: "555-555-5555", contact_email: "test@example.com",
  goal: "We want 1 out of every 5 Americans to have a huggey bear.")

amnesty_international = Organization.create(name: "Amnesty International", cause: "Human Rights", ruling_year: 1912,
  mission_statement: "We want to see human rights spread across the globe -- chyea.", guidestar_membership: nil, 
  ein: "987931299-1", street1: "3293 Dunnit Hill", street2: nil, city: "New York", 
  state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil,
  budget: "$22,000,000.00", contact_number: "555-555-5555", contact_email: "test@example.com",
  goal: "Every year we want at least one thousand human rights activists released from prisons around the world.")
global_giving = Organization.create(name: "Global Giving", cause: "Social Good", ruling_year: 2000, 
  mission_statement: "We make it rain on Nonprofits, erreday", guidestar_membership: nil, 
  ein: "222222222-2", street1: "2222 Rick Ross", street2: nil, city: "DC", 
  state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil,
  budget: "$22,000,000.00", contact_number: "555-555-5555", contact_email: "test@example.com",
  goal: "We want each of our nonprofit partners to raise at least $ 5,000.00 from our platform a year.")

User.destroy_all
huggey_bear = Fabricate(:organization, name: "Huggey Bear Land", cause: "Animal Rights", 
  ruling_year: 1998, mission_statement: "We want to give everyone a huggey bear in their sad times", 
  guidestar_membership: nil, ein: "192512653-6", street1: "2998 Hansen Heights", 
  street2: nil, city: "New York", state_id: 0, zip: "28200-1366", 
  ntee_major_category_id: 0, funding_method: nil, user_id: nil,budget: "$22,000,000.00", 
  contact_number: "555-555-5555", contact_email: "test@example.com", 
  goal: "We want 1 out of every 5 Americans to have a huggey bear.")
amnesty = Fabricate(:organization, name: "Amnesty International", cause: "Human Rights", 
  ruling_year: 1912, mission_statement: "We want to see human rights spread across the globe -- chyea.", 
  guidestar_membership: nil, ein: "987931299-1", street1: "3293 Dunnit Hill", 
  street2: nil, city: "New York", state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, 
  funding_method: nil, user_id: nil, budget: "$22,000,000.00", contact_number: "555-555-5555", 
  contact_email: "test@example.com", goal: "Every year we want at least one thousand human rights activists released from prisons around the world.")

alice_smith = Fabricate(:user, organization_id: 1, first_name: "Alice", 
  last_name: "Smith", email: "alice@huggey_bear.org", 
  interests: "animal rights", skills: "grant writing", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, 
  organization_administrator: true, organization_staff: nil, volunteer: nil, 
  position: "Executive Director", user_group: "nonprofit")
bob_adams = Fabricate(:user, organization_id: 2, first_name: "Bob", 
  last_name: "Adams", email: "bob@amnesty.org", 
  interests: "human rights", skills: "web development", street1: nil, street2: nil, 
  city: "Miami", state_id: "FL", phone_number: nil, zip: nil, 
  organization_administrator: true, organization_staff: nil, volunteer: nil, 
  position: "Executive Director", user_group: "nonprofit")

cat_mckenzie = Fabricate(:user, organization_id: 1, first_name: "Catherine", 
  last_name: "McKenzie", email: "cat@huggey_bear.org", 
  interests: "animal rights", skills: "graphic design", street1: nil, street2: nil, 
  city: "San Francisco", state_id: "CA", phone_number: nil, zip: nil, 
  organization_staff: true, position: "designer", user_group: "nonprofit")
dan_quale = Fabricate(:user, organization_id: 1, first_name: "Dan", 
  last_name: "Quale", email: "dan@amnesty.org", 
  interests: "human rights", skills: "web development", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, 
  organization_staff: true, position: "developer", user_group: "nonprofit")

elena_washington = Fabricate(:user, first_name: "Elena", last_name: "Washington", 
  email: "elena@example.org", interests: "animal rights", skills: "graphic design", 
  street1: nil, street2: nil, city: "New York", state_id: "NY", phone_number: nil, 
  zip: nil, organization_administrator: nil, organization_staff: nil, volunteer: true, 
  user_group: "volunteer")
frank_daniels = Fabricate(:user, first_name: "Frank", last_name: "Daniels", 
  email: "frank@example.org", interests: "environment", skills: "fundraising", 
  street1: nil, street2: nil, city: "Birmingham", state_id: "AL", phone_number: nil, 
  zip: nil, organization_administrator: nil, organization_staff: nil, volunteer: true, 
  user_group: "volunteer")
george_smith = Fabricate(:user, first_name: "George", last_name: "Smith", 
  email: "george@example.org", interests: "human rights", skills: "web development", 
  street1: nil, street2: nil, city: "Boston", state_id: "MA", phone_number: nil, 
  zip: nil, organization_administrator: nil, organization_staff: nil, volunteer: true, 
  user_group: "volunteer")
harry_ortega = Fabricate(:user, first_name: "Harry", last_name: "Ortega", 
  email: "harry@example.org", interests: "animal rights", skills: "social media", 
  street1: nil, street2: nil, city: "Boston", state_id: "MA", phone_number: nil, 
  zip: nil, organization_administrator: nil, organization_staff: nil, volunteer: true, 
  user_group: "volunteer")
isabel_david = Fabricate(:user, first_name: "Isabel", last_name: "David", 
  email: "isabel@example.org", interests: "environment", skills: "web development", 
  street1: nil, street2: nil, city: "New York", state_id: "NY", phone_number: nil, 
  zip: nil, organization_administrator: nil, organization_staff: nil, volunteer: true, 
  user_group: "volunteer")
jacob_seltzer = Fabricate(:user, first_name: "Jacob", last_name: "Seltzer", 
  email: "jacob@example.org", interests: "urban affairs", skills: "web development", 
  street1: nil, street2: nil, city: "New York", state_id: "NY", phone_number: nil, 
  zip: nil, organization_administrator: nil, organization_staff: nil, volunteer: true, 
  user_group: "volunteer")
=begin
alice = User.create(organization_id: 1, first_name: "Alice", last_name: "Smith", email: "alice@huggey_bear.org", 
  interests: "Animal Rights", skills: "Grant Writing", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
  organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password", user_group: "nonprofit")
bob = User.create(organization_id: 2, first_name: "Bob", last_name: "Adams", email: "bob@amnesty.org", 
  interests: "Human Rights", skills: "Web Development", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
  organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password", user_group: "nonprofit")
catherine = User.create(organization_id: 3, first_name: "Catherine", last_name: "Hemingway", email: "cat@globalgiving.org", 
  interests: "Health", skills: "Graphic Design", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
  organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password", user_group: "nonprofit")
dan = User.create(organization_id: 1, first_name: "Daniel", last_name: "Montgomey", email: "dan@huggey_bear.org", 
  interests: "Urban Affairs", skills: "Business Development", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Business Development Executive", password: "password", user_group: "nonprofit")
elena = User.create(organization_id: 1, first_name: "Elena", last_name: "Lincoln", email: "elena@huggey_bear.org", 
  interests: "International Development", skills: "Social Media", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Fundraising Manager", password: "password", user_group: "nonprofit")
fred = User.create(organization_id: 2, first_name: "Fred", last_name: "Montgomery", email: "fred@amnesty.org", 
  interests: "Youth and Development", skills: "Accounting", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Junior Associate", password: "password", user_group: "nonprofit")
genna = User.create(organization_id: 2, first_name: "Genna", last_name: "Kennedy", email: "genna@amnesty.org", 
  interests: "Politics", skills: "Events", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Event Coordinator", password: "password", user_group: "nonprofit")
harry = User.create(organization_id: 3, first_name: "Harry", last_name: "Swift", email: "harry@global.org", 
  interests: "Tech", skills: "Finance", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Financial Officer", password: "password", user_group: "nonprofit")
ingrid = User.create(organization_id: 3, first_name: "Ingrid", last_name: "Washington", email: "ingrid@global.org", 
  interests: "Architecture", skills: "Drafting", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "IT", password: "password", user_group: "nonprofit")
jacob = User.create(first_name: "Jacob", last_name: "Seltzer", email: "jacob@example.org", 
  interests: "Web Development", skills: "ROR", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: nil, volunteer: true, password: "password", user_group: "volunteer")
=end

huggey_bears.update_columns(user_id: 1)
amnesty_international.update_columns(user_id: 2)
global_giving.update_columns(user_id: 3)


Project.destroy_all
word_press = Project.create(title: "Need WordPress Site", description: "I want a nice looking WordPress site for my nonprofit", 
  skills: "web development", causes: "animals", deadline: Date.today + 1.month, user_id: 1, organization_id: 1, estimated_hours: 22, state: "open")
pretty_logo = Project.create(title: "Elegant Logo", description: "I want a logo that reflects the strenght of the human spirit!", 
  skills: "graphic design", causes: "human rights", deadline: Date.today + 1.month, user_id: 2, organization_id: 2, estimated_hours: 32, state: "open")
social_media = Project.create(title: "Twitter Help", description: "I need someone to push out 10 tweets a day for me", 
  skills: "social media", causes: "social", deadline: Date.today + 1.month, user_id: 3, organization_id: 3, estimated_hours: 11, state: "open")
fundraising = Project.create(title: "Fundraising Help", description: "I need help fundraising my organization", 
  skills: "fundraising", causes: "animals", deadline: Date.today + 1.month, user_id: 1, organization_id: 1, estimated_hours: 22, state: "open")

Contract.destroy_all
  
PrivateMessage.destroy_all
Conversation.destroy_all