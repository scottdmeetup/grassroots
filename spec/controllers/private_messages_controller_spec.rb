require 'spec_helper'

describe PrivateMessagesController, :type => :controller do
  let(:alice) { Fabricate(:organization_administrator, organization_id: nil, first_name: "Alice", last_name: "Smith", user_group: "nonprofit") }
  let(:bob) { Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
  let(:huggey_bear) { Fabricate(:organization, user_id: alice.id) }
  let(:word_press) { Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") }
  let(:contract) { Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id, work_submitted: nil) } 
  
  
  describe "GET new" do

    before do
      alice.update_columns(organization_id: huggey_bear.id)
    end
    context "When only sending a message" do
      let(:bob) { Fabricate(:user, first_name: "Bob", user_group: "volunteer") }

      it "renders the new template for creating a private message" do
        get :new, user_id: bob.id

        expect(response).to render_template(:new)
      end

      it "sets the recipient value to that of the submitted parameters, @user" do
        get :new, user_id: bob.id

        expect(assigns(:private_message).recipient_id).to eq(bob.id)
      end

      it "does not associate a project id with the initialized @private_message" do
        get :new, user_id: bob.id

        expect(assigns(:private_message).project_id).to be_nil
      end
    end
  end

  describe "POST create" do
    let(:bob) { Fabricate(:user, first_name: "Bob", user_group: "volunteer") }
    let(:alice) { Fabricate(:user, first_name: "Alice", user_group: "nonprofit") }
    context "with valid input" do
      context "when writing the just a message to a user" do
        before do
          session[:user_id] = bob.id
        end

        it "redirects to the conversation index" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}
          expect(response).to redirect_to(conversations_path)
        end

        it "creates a private message" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}
          
          expect(PrivateMessage.count).to eq(1)
        end
        it "creates a conversation" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}
          
          expect(Conversation.count).to eq(1)
        end

        it "creates a new, unique conversation id for the message" do
          convo1 = Conversation.create
          message1 = Fabricate(:private_message, conversation_id: convo1.id, subject: "test", body: "test 123")
          convo2 = Conversation.create
          message2 = Fabricate(:private_message, conversation_id: convo2.id, subject: "foo bar", body: "foo bar 123")
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}

          message3 = PrivateMessage.find(3)
          convo3 = Conversation.find(3)
          
          expect(message3.conversation).to eq(convo3)
        end

        it "associates the recipient with a received message" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}
          
          message = PrivateMessage.first
          expect(alice.received_messages).to eq([message])
        end
        it "associates the sender with the sent message" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}
          
          message = PrivateMessage.first
          expect(bob.sent_messages).to eq([message])
        end
        it "associates the private message with a conversation" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}
          
          message = PrivateMessage.first
          convo = Conversation.first
          expect(message.conversation).to eq(convo)
        end
        it "associates the recipient with the conversation" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}

          convo = Conversation.first
          expect(alice.user_conversations).to eq([convo])
        end
      end

      context "when creating reply" do

        before do
          session[:user_id] = alice.id
        end

        it "adds another message to the database" do
          message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
          post :create, private_message: {recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Your qualifications look great. What's your phone number?"}

          expect(PrivateMessage.count).to eq(2)
        end

        it "associates the reply message with the original message's conversation" do
          convo = Conversation.create
          message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
          post :create, private_message: {recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Your qualifications look great. What's your phone number?", conversation_id: message1.conversation_id}

          convo = Conversation.first
          message2 = PrivateMessage.find(2)
          expect(convo.private_messages).to eq([message1, message2])
        end

        it "adds a conversation to the original sender's conversation index" do
          convo = Conversation.create
          message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
          post :create, private_message: {recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Your qualifications look great. What's your phone number?", conversation_id: message1.conversation_id}

          convo = Conversation.first
          message2 = PrivateMessage.find(2)
          expect(bob.user_conversations).to eq([convo])
        end
      end
    end
  end
=begin
          it "sends the application to the project administrator" do
            post :create, project_id: word_press.id, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}
            expect(alice.conversations.first).to eq(Conversation.first)
          end

          it "associates the project with the applicant" do
            post :create, project_id: word_press.id, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}
            expect(bob.projects_with_open_applications).to eq([word_press])
          end

        end

        #it "creates a volunteer application"
        #it "creates a conversation id with a unique volunteer application foreign key"
        #it "makes the recipient of the message see a conversation, which has a volunteer_application_id" 


        #conversation1 = double(:volunteer_app, id: 1, update_columns: 1)
        #message1 = double(:volunteer_app, update_columns: conversation1.id, recipient_id: 2)
        #Conversation.should_receive(:create).and_return(conversation1)
        #PrivateMessage.should_receive(:create).and_return(message1)

        it "associates the user who is sending the message with the project" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(bob.projects).to eq([word_press])
        end

        it "sets the private message variable with the project id" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(PrivateMessage.first.project_id).to eq(word_press.id)
        end

        it "flashes a messages confirming delivery" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(flash[:success]).to eq("Your message has been sent to #{alice.first_name} #{alice.last_name}")
        end

        it "makes the project's state remain open" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(word_press.state).to eq("open")
        end

      context "when sending a completed project request" do
        #let (:message1) {Fabricate(:project, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id)}
        let(:word_press) { Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "in production") }
        
        before do 
          session[:user_id] = bob.id
          word_press.users << [bob, alice]
        end

        it "moves the projects state to pending completion" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(Project.first.state).to eq("pending completion")
        end

        it "redirects the current user to the current user's profile page" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(response).to redirect_to(user_path(bob.id))
        end

        it "disassociates the other message that approves the volunteer from the project " do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(response).to redirect_to(user_path(bob.id))
        end
      end

      context "when completing a project" do
        let(:word_press) { Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "in production") }
        
        before do 
          session[:user_id] = bob.id
          word_press.users << [bob, alice]
        end

        it "sets the private message with the project id" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(PrivateMessage.first.project_id).to eq(word_press.id)
        end

        it "does not add the current user to the project a second time" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(word_press.users).to eq([bob, alice])
        end

        it "flashes a message confirming delivery" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"}, project_id: word_press.id

          expect(flash[:success]).to eq("Your message has been sent to #{alice.first_name} #{alice.last_name}")
        end
      end
=end
end