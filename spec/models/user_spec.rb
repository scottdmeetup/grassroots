require 'spec_helper'

describe User do
  it { should belong_to(:organization)}
  it { should belong_to(:project)}
  #it { should have_many(:project_users)}
  #it { should have_many(:projects).through(:project_users)}
  it { should have_many(:sent_messages)}
  it { should have_many(:received_messages).order("created_at DESC")}
  it { should have_many(:received_applications)}
  it { should have_many(:sent_applications)}
  it { should have_many(:volunteer_applications)}
  it { should have_many(:projects).through(:volunteer_applications)}
  #it { should have_many(:projects).through(:volunteer_applications)}

  describe "#private_messages" do
    it "returns all the conversations of the user in an arry" do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", user_group: "nonprofit")
      alice = Fabricate(:user, first_name: "Alice", user_group: "volunteer")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "my phone number is 123455", conversation_id: convo.id)
      message4 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Great I will call you in a bit", conversation_id: convo.id)

      expect(bob.private_messages).to eq([message1, message2, message3, message4])
    end
  end


  describe "#user_conversations" do
    it "returns a conversation of the user in an arry if there is only one received smessages" do
      convo1 = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", user_group: "nonprofit")
      alice = Fabricate(:user, first_name: "Alice", user_group: "volunteer")
      
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo1.id)
      

      expect(alice.user_conversations).to eq([convo1])
    end

    it "does not return a conversation of the user in an arry if there is only one sent smessages" do
      convo1 = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", user_group: "nonprofit")
      alice = Fabricate(:user, first_name: "Alice", user_group: "volunteer")
      
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo1.id)
      

      expect(bob.user_conversations).to eq([])
    end

    it "returns an array of multiple conversations of the user if there are multiple senders" do
      convo1 = Conversation.create
      convo2 = Conversation.create
      convo3 = Conversation.create
      
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      alice = Fabricate(:user, first_name: "Alice", user_group: "nonprofit")
      cat = Fabricate(:user, first_name: "Cat", user_group: "volunteer")
      dan = Fabricate(:user, first_name: "Dan", user_group: "volunteer")

      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo1.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo1.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: cat.id, subject: "Please let me join your project", body: "I'd really like to help out with your project", conversation_id: convo2.id)
      message4 = Fabricate(:private_message, recipient_id: cat.id, sender_id: alice.id, subject: "Please let me join your project", body: "Let's talk. I think you could be a great asset.", conversation_id: convo2.id)
      message5 = Fabricate(:private_message, recipient_id: alice.id, sender_id: dan.id, subject: "Please let me join your project", body: "I think your project is cool, and I want to help out.", conversation_id: convo3.id)

      expect(alice.user_conversations).to eq([convo1, convo2, convo3])
    end

    it "does not return duplicate conversations" do
      convo1 = Conversation.create

      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      alice = Fabricate(:user, first_name: "Alice", user_group: "nonprofit")

      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo1.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo1.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd really like to help out with your project", conversation_id: convo1.id)
      

      expect(alice.user_conversations).to eq([convo1])
    end
  end

  describe "#organization_name" do
    it "returns the name of the organization of the user" do
      alice = Fabricate(:user, first_name: "Alice", user_group: "nonprofit")
      org = Fabricate(:organization)
      alice.update(organization_id: 1)

      expect(alice.organization_name).to eq(org.name)
    end
  end

  describe "#open_projects" do
    it "returns the users projects that are open" do
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      word_press = Fabricate(:project, state: "open")
      logo = Fabricate(:project, state: "in production")
      bob.projects << [word_press, logo]

      expect(bob.open_projects).to eq([word_press])
    end
  end

  describe "#in_production_projects" do
    it "returns the users projects that are in production" do
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      word_press = Fabricate(:project, state: "open")
      logo = Fabricate(:project, state: "in production")
      bob.projects << [word_press, logo]

      expect(bob.in_production_projects).to eq([logo])
    end
  end

  describe "#pending_completion_projects" do
    it "returns the users projects that are pending completion" do
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      word_press = Fabricate(:project, state: "open")
      logo = Fabricate(:project, state: "pending completion")
      bob.projects << [word_press, logo]

      expect(bob.pending_completion_projects).to eq([logo])
    end
  end

  describe "#completed_projects" do
    it "returns the users projects that are completed" do
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      word_press = Fabricate(:project, state: "open")
      logo = Fabricate(:project, state: "completed")
      bob.projects << [word_press, logo]

      expect(bob.completed_projects).to eq([logo])
    end
  end

  describe "#unfinished_projects" do
    it "returns the users projects that are unfinished" do
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      word_press = Fabricate(:project, state: "open")
      logo = Fabricate(:project, state: "unfinished")
      bob.projects << [word_press, logo]

      expect(bob.unfinished_projects).to eq([logo])
    end
  end

  describe "#projects_of_open_volunteer_applications" do
    it "returns the users projects to which he/she has applied only if accepted and rejectes are nil" do
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      alice = Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")
      cat = Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")
      
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      amnesty = Fabricate(:organization, user_id: cat.id)
      
      logo = Fabricate(:project, title: "need a logo", user_id: cat.id, organization_id: amnesty.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      accounting = Fabricate(:project, title: "accounting", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      grant_writing = Fabricate(:project, title: "grant writing job", user_id: cat.id, organization_id: amnesty.id, state: "open") 
      
      application1 = Fabricate(:volunteer_application, user_id: bob.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      
      application2 = Fabricate(:volunteer_application, user_id: bob.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id) 
      message2 = Fabricate(:private_message, recipient_id: cat.id, sender_id: bob.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)
      
      application3 = Fabricate(:volunteer_application, user_id: bob.id, project_id: accounting.id, rejected: true)
      conversation3 = Fabricate(:conversation, volunteer_application_id: application3.id) 
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation3.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: accounting.id)

      application4 = Fabricate(:volunteer_application, user_id: bob.id, project_id: grant_writing.id, accepted: true)
      conversation4 = Fabricate(:conversation, volunteer_application_id: application4.id) 
      message4 = Fabricate(:private_message, recipient_id: cat.id, sender_id: bob.id, conversation_id: conversation4.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: grant_writing.id)

      expect(bob.projects_of_open_volunteer_applications).to eq([word_press, logo])
    end
  end

  #describe "open_volunteer_applications"
  describe "#volunteers_open_applications" do
    it "returns all open applications for the volunteer" do
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      alice = Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")
      huggey_bear = Fabricate(:organization, user_id: alice.id)

      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(user_id: bob.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
          
      application2 = VolunteerApplication.create(user_id: bob.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id) 
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)

      expect(bob.volunteers_open_applications).to eq([application1, application2])
    end
  end
  describe "#administrators_open_applications" do
    it "returns all project participation request applications for the administrator" do
      cat = Fabricate(:user, first_name: "Cat", user_group: "volunteer")
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      alice = Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      alice.update_attributes(organization_id: huggey_bear.id)

      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(user_id: bob.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
          
      application2 = VolunteerApplication.create(user_id: cat.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id) 
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: cat.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)

      expect(alice.administrators_open_applications).to eq([application1, application2])
    end
  end
  describe "#applied_to_projects" do
    it "returns all of the volunteer's projects to which he has applied to join" do
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
      alice = Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")
      huggey_bear = Fabricate(:organization, user_id: alice.id)

      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
          
      application2 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id) 
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)

      expect(bob.applied_to_projects).to eq([logo, word_press])
    end
  end
end
  