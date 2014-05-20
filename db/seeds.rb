Organization.destroy_all
huggey_bears = Organization.create(name: "Huggey Bear Land", cause: "Animal Rights", ruling_year: 1998, 
  mission_statement: "We want to give everyone a huggey bear in their sad times", guidestar_membership: nil, 
  ein: "192512653-6", street1: "2998 Hansen Heights", street2: nil, city: "New York", 
  state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil)

amnesty_international = Organization.create(name: "Amnesty International", cause: "Human Rights", ruling_year: 1912,
  mission_statement: "We want to see human rights spread across the globe -- chyea.", guidestar_membership: nil, 
  ein: "987931299-1", street1: "3293 Dunnit Hill", street2: nil, city: "New York", 
  state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil)
global_giving = Organization.create(name: "Global Giving", cause: "Social Good", ruling_year: 2000, 
  mission_statement: "We make it rain on Nonprofits, erreday", guidestar_membership: nil, 
  ein: "222222222-2", street1: "2222 Rick Ross", street2: nil, city: "DC", 
  state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil)

User.destroy_all
alice = User.create(organization_id: 1, first_name: "Alice", last_name: "Smith", email: "alice@huggey_bear.org", 
  interests: "Animal Rights", skills: "Grant Writing", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
  organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password")
bob = User.create(organization_id: 2, first_name: "Bob", last_name: "Adams", email: "bob@amnesty.org", 
  interests: "Human Rights", skills: "Web Development", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
  organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password")
catherine = User.create(organization_id: 3, first_name: "Catherine", last_name: "Hemingway", email: "cat@globalgiving.org", 
  interests: "Health", skills: "Graphic Design", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
  organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password")
dan = User.create(organization_id: 1, first_name: "Daniel", last_name: "Montgomey", email: "dan@huggey_bear.org", 
  interests: "Urban Affairs", skills: "Business Development", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Business Development Executive", password: "password")
elena = User.create(organization_id: 1, first_name: "Elena", last_name: "Lincoln", email: "elena@huggey_bear.org", 
  interests: "International Development", skills: "Social Media", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Fundraising Manager", password: "password")
fred = User.create(organization_id: 2, first_name: "Fred", last_name: "Montgomery", email: "fred@amnesty.org", 
  interests: "Youth and Development", skills: "Accounting", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Junior Associate", password: "password")
genna = User.create(organization_id: 2, first_name: "Genna", last_name: "Kennedy", email: "genna@amnesty.org", 
  interests: "Politics", skills: "Events", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Event Coordinator", password: "password")
harry = User.create(organization_id: 3, first_name: "Harry", last_name: "Swift", email: "harry@global.org", 
  interests: "Tech", skills: "Finance", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "Financial Officer", password: "password")
ingrid = User.create(organization_id: 3, first_name: "Ingrid", last_name: "Washington", email: "ingrid@global.org", 
  interests: "Architecture", skills: "Drafting", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: true, volunteer: nil, position: "IT", password: "password")
jacob = User.create(first_name: "Jacob", last_name: "Seltzer", email: "jacob@example.org", 
  interests: "Web Development", skills: "ROR", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: nil, volunteer: true, password: "password")

huggey_bears.update_columns(user_id: 1)
amnesty_international.update_columns(user_id: 2)
global_giving.update_columns(user_id: 3)


Project.destroy_all
word_press = Project.create(title: "Need WordPress Site", description: "I want a nice looking WordPress site for my nonprofit", 
  skills: "WordPress", causes: "Animal Rights", deadline: Date.today + 1.month, user_id: 1, organization_id: 1, estimated_hours: 22, state: "open")
pretty_logo = Project.create(title: "Elegant Logo", description: "I want a logo that reflects the strenght of the human spirit!", 
  skills: "Graphic Design", causes: "Human Rights", deadline: Date.today + 1.month, user_id: 2, organization_id: 2, estimated_hours: 32, state: "open")
social_media = Project.create(title: "Twitter Help", description: "I need someone to push out 10 tweets a day for me", 
  skills: "Social Media", causes: "Social Good", deadline: Date.today + 1.month, user_id: 3, organization_id: 3, estimated_hours: 11, state: "open")
fundraising = Project.create(title: "Fundraising Help", description: "I need help fundraising my organization", 
  skills: "Fundraising", causes: "Animal Rights", deadline: Date.today + 1.month, user_id: 1, organization_id: 1, estimated_hours: 22, state: "open")
alice.projects << word_press
bob.projects << pretty_logo
catherine.projects << social_media
alice.projects << fundraising

PrivateMessage.destroy_all
Conversation.destroy_all