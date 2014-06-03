require 'spec_helper'

feature "Administrator interacts with various applications, contracts and messages in his/her inbox queue" do
 let(:huggey_bear) {Fabricate(:organization, name: "Huggey Bear Land", cause: "Animal Rights", ruling_year: 1998, 
   mission_statement: "We want to give everyone a huggey bear in their sad times", guidestar_membership: nil, 
   ein: "192512653-6", street1: "2998 Hansen Heights", street2: nil, city: "New York", 
   state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil,
   budget: "$22,000,000.00", contact_number: "555-555-5555", contact_email: "test@example.com",
   goal: "We want 1 out of every 5 Americans to have a huggey bear.")}

let(:alice) {Fabricate(:user, organization_id: 1, first_name: "Alice", last_name: "Smith", email: "alice@huggey_bear.org", 
  interests: "Animal Rights", skills: "Grant Writing", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
  organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password", user_group: "nonprofit")}

let(:bob) {Fabricate(:user, first_name: "Bob", last_name: "Seltzer", email: "jacob@example.org", 
  interests: "Web Development", skills: "ROR", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: nil, volunteer: true, password: "password", user_group: "volunteer")}
  
let(:word_press) {Fabricate(:project, title: "Need WordPress Site", description: "I want a nice looking WordPress site for my nonprofit", 
  skills: "web development", causes: "animals", deadline: Date.today + 1.month, 
  user_id: alice.id, organization_id: huggey_bear.id, estimated_hours: 22, state: "open")}

let(:logo) {Fabricate(:project, title: "need a logo", user_id: alice.id, 
  organization_id: huggey_bear.id, state: "open")  }

let(:cat) {Fabricate(:organization_administrator, first_name: "Cat", user_group: "volunteer")}
let(:dan) {Fabricate(:organization_administrator, first_name: "Dan", user_group: "volunteer")}

  scenario "" do
    
  end

  scenario "" do
    
  end

  scenario "" do
   
  end

  
end