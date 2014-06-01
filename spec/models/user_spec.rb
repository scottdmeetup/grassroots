require 'spec_helper'

describe User do
  it { should belong_to(:organization)}
  it { should have_many(:sent_messages)}
  it { should have_many(:received_messages).order("created_at DESC")}
  it { should have_many(:received_applications)}
  it { should have_many(:sent_applications)}
  it { should have_many(:jobs)}
  it { should have_many(:procurements)}
  

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

  describe "#projects_in_production" do
    let(:huggey_bear) {Fabricate(:organization)}
    let(:amnesty) {Fabricate(:organization)}
    let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
    let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
    let(:cat) {Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")}

    let(:logo) {Fabricate(:project, title: "need a logo", user_id: cat.id, organization_id: amnesty.id)  }
    let(:word_press) {Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id) }
    #let(:accouting) {Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)}

    before do
      huggey_bear.update_columns(user_id: alice.id)
      amnesty.update_columns(user_id: cat.id)
    end

    it "returns the projects that are in production because of a contract" do    
      accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)

      contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id, work_submitted: nil)
      contract2 =  Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: logo.id, work_submitted: nil)
      contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: nil, project_id: accounting.id)

      expect(bob.projects_in_production).to eq([word_press, logo])
    end

    describe "#submitted_work" do
      let(:huggey_bear) {Fabricate(:organization)}
      let(:amnesty) {Fabricate(:organization)}
      let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
      let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
      let(:cat) {Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")}

      let(:logo) {Fabricate(:project, title: "need a logo", user_id: cat.id, organization_id: amnesty.id)  }
      let(:word_press) {Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id) }
      #let(:accouting) {Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)}

      before do
        huggey_bear.update_columns(user_id: alice.id)
        amnesty.update_columns(user_id: cat.id)
      end

      it "returns all the projects for which the volunteer has submitted work to the contractor" do
        accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)

        contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id, work_submitted: true, incomplete: false)
        contract2 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: logo.id, work_submitted: true, incomplete: false)
        contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: accounting.id, work_submitted: false)

        expect(bob.submitted_work).to eq([word_press, logo])
      end
    end

    describe "#projects_completed" do
      let(:huggey_bear) {Fabricate(:organization)}
      let(:amnesty) {Fabricate(:organization)}
      let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
      let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
      let(:cat) {Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")}

      let(:logo) {Fabricate(:project, title: "need a logo", user_id: cat.id, organization_id: amnesty.id)  }
      let(:word_press) {Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id) }
      #let(:accouting) {Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)}

      before do
        huggey_bear.update_columns(user_id: alice.id)
        amnesty.update_columns(user_id: cat.id)
      end
      it "returns all the projects for which the volunteer has completed" do

        accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)

        contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id, work_submitted: true)
        contract2 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: false, project_id: logo.id, work_submitted: false, complete: true)
        contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: accounting.id, work_submitted: false)

        expect(bob.projects_complete).to eq([logo])
      end
    end

    describe "#applied_to_projects" do

      let(:huggey_bear) {Fabricate(:organization)}
      let(:amnesty) {Fabricate(:organization)}
      let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
      let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
      let(:cat) {Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")}

      let(:logo) {Fabricate(:project, title: "need a logo", user_id: cat.id, organization_id: amnesty.id)  }
      let(:word_press) {Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id) }

      before do
        huggey_bear.update_columns(user_id: alice.id)
        amnesty.update_columns(user_id: cat.id)
      end

      it "returns all the projects to which the volunteer applied" do
        bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")
        alice = Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")
        cat = Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")
        
        huggey_bear = Fabricate(:organization, user_id: alice.id)
        amnesty = Fabricate(:organization, user_id: cat.id)
        
        accounting = Fabricate(:project, title: "accounting", user_id: alice.id, organization_id: huggey_bear.id) 
        grant_writing = Fabricate(:project, title: "grant writing job", user_id: cat.id, organization_id: amnesty.id) 
        
        application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
        application2 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: accounting.id, rejected: true)
        application3 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: cat.id, project_id: logo.id)
        application4 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: cat.id, project_id: grant_writing.id, accepted: true)

        expect(bob.applied_to_projects).to eq([word_press, logo])
      end
    end

    describe "drop_contract(agreement)" do
        let(:huggey_bear) {Fabricate(:organization)}
        let(:amnesty) {Fabricate(:organization)}
        let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
        let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
        let(:cat) {Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")}

        let(:logo) {Fabricate(:project, title: "need a logo", user_id: cat.id, organization_id: amnesty.id)  }
        let(:word_press) {Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id) }
        #let(:accouting) {Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)}

        before do
          huggey_bear.update_columns(user_id: alice.id)
          amnesty.update_columns(user_id: cat.id)
        end
      it "dissassociates the user from the contract when the user wants to drop it" do
       
        accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)

        contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id, work_submitted: true)
        contract2 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: false, project_id: logo.id, work_submitted: false, complete: true)
        contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: accounting.id)
        bob.drop_contract(contract3)

        expect(bob.projects_in_production).to eq([])
      end
    end
  end
end
  