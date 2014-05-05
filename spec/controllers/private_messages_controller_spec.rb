require 'spec_helper'


describe PrivateMessagesController do
  let(:alice) { Fabricate(:organization_administrator, organization_id: nil, first_name: "Alice") }
  let(:huggey_bear) { Fabricate(:organization, user_id: alice.id) }
  let(:word_press) { Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id) }
  
  describe "GET new" do

    before do
      alice.update_columns(organization_id: huggey_bear.id)
    end

    it "renders the new template for creating a private message" do
      get :new, project_id: word_press.id

      expect(response).to render_template(:new)
    end
    it "sets @private_message" do
      get :new, project_id: word_press.id

      expect(assigns(:private_message)).to be_instance_of(PrivateMessage)
    end
    
    context "when sending a join request" do
      it "sets the @project.id" do
        get :new, project_id: word_press.id

        expect(assigns(:private_message).project_id).to eq(1)
      end
      it "sets the recipient value" do
        get :new, project_id: word_press.id

        expect(assigns(:private_message).recipient).to eq(alice)
      end
      it "sets the subject line with the value of the project title with Project Request:" do
        get :new, project_id: word_press.id

        expect(assigns(:private_message).subject).to eq("Project Request: word press website")
      end
    end
  end

  describe "POST create" do
    let(:bob) { Fabricate(:user, first_name: "Bob") }
    let(:alice) { Fabricate(:user, first_name: "Alice") }
    context "with valid input" do

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
=begin
      context "when requesting to join a project" do
        before do
          alice.update_columns(organization_id: huggey_bear.id)
          session[:user_id] = bob.id
        end

        it "changes the project's state from open to pending" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          word_press = Project.first
          expect(word_press.state).to eq('pending')
        end
        it "changes the project’s state from open to pending on the freelancers dashboard" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          expect(bob.projects).to eq([word_press])
        end
        
        it "makes the organization admin receive a private message from the freelancer" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          message = PrivateMessage.first
          expect(alice.received_messages).to eq([message])
        end

        it "creates a conversation for the organization admin" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          expect(alice.conversations.count).to eq(1)
        end

        it "associates the private message with the conversation" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          message1 = PrivateMessage.first
          conversation1 = Conversation.first
          expect(message1.conversation).to eq(conversation1)
        end
        
        it "stores the private message in the freelancer's index of sent private messages" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          message = PrivateMessage.first
          expect(bob.sent_messages).to eq([message])
        end

        it "flash's a success notice that your join request has been sent" do
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          expect(flash[:success]).to eq("Your join request has been sent.")
        end
        it "adds the freelancer's thumbnail photo to the project's details"
        it "remains open on the project index"
        it "triggers a private message alert on the recipient's notification icon"
        it "notifies the organization admin that a user wants to join his/her project"
        it "sends out an email to the recipient notifying him/her"
      end

      context "when sending a reply to a message" do

        before do
          alice.update_columns(organization_id: huggey_bear.id)
          session[:user_id] = alice.id
        end

        it "adds a message to a conversation" do
          conversation1 = Conversation.create
          message1 =  Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
          post :create, private_message: { recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk." }, private_message_id: message1.id

          conversation1 = Conversation.first
          expect(conversation1.private_messages.count).to eq(2)
        end

        it "adds two private messages to a conversation" do
          conversation1 = Conversation.create
          message1 =  Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
          post :create, private_message: { recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk." }, private_message_id: message1.id

          conversation = Conversation.first
          expect(conversation.private_messages.count).to eq(2)
        end

        it "associates two private messages with a conversation" do
          conversation1 = Conversation.create
          message1 =  Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
          post :create, private_message: { recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk." }, private_message_id: message1.id

          conversation = Conversation.first
          message2 = PrivateMessage.find(2)
          expect(conversation.private_messages).to eq([message1, message2])
        end

        it "makes the current user have a conversation" do
          conversation1 = Conversation.create
          message1 =  Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
          post :create, private_message: { recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk." }, private_message_id: message1.id

          expect(alice.conversations).to eq([conversation1])
        end

        it "makes the recipient of the reply message have a conversation" do
          conversation1 = Conversation.create
          message1 =  Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
          post :create, private_message: { recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk." }, private_message_id: message1.id

          expect(bob.conversations).to eq([conversation1])
        end

        it "makes the conversation have two users" do
          conversation1 = Conversation.create
          message1 =  Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
          post :create, private_message: { recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk." }, private_message_id: message1.id

          expect(conversation1.users.count).to eq(2)
        end

        it "flashes a message to the current user about a successful sent message" do
          conversation1 = Conversation.create
          message1 =  Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
          post :create, private_message: { recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk." }, private_message_id: message1.id

          expect(flash[:success]).to eq("Your message has been sent.")
        end
      end

    end
    context "with invalid input" do
      it "renders the new template" do
        alice.update_columns(organization_id: huggey_bear.id)
        post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, body: "I'd like to contribute to your project", project_id: word_press.id}

        expect(response).to render_template("new")
      end
    end
=end
  end

  describe "GET show" do
    let(:bob) { Fabricate(:user) }
    let(:message) { Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") }

    before do
      alice.update_columns(organization_id: huggey_bear.id)
      session[:user_id] = bob.id
    end

    it "renders the show template for a private message" do
      get :show, id: message.id
      expect(response).to render_template(:show)
    end

    it "shows a received private message" do
      get :show, id: message.id
      expect(message.subject).to eq("Please let me join your project")
    end
    it "sets @message" do
      get :show, id: message.id
      expect(assigns(:message)).to eq(message)
    end
    context "when replying to a message" do
      
      before do
        session[:user_id] = alice.id
      end

      it "sets the @private_message to new" do
        get :show, id: message.id

        expect(assigns(:private_message)).to be_a PrivateMessage
      end

      it "sets the recipient value" do
        get :show, id: message.id

        expect(assigns(:private_message).recipient).to eq(bob)
      end
      it "sets the sender value" do
        get :show, id: message.id

        expect(assigns(:private_message).sender).to eq(alice)
      end
      it "sets the subject line with the value of the message title with Project Request: the message's title" do
        get :show, id: message.id

        expect(assigns(:private_message).subject).to eq("Please let me join your project")
      end

      it "sets the conversation id of the sent message" do
        convo = message.conversation
        get :show, id: message.id

        expect(assigns(:private_message).conversation).to eq(convo)
      end
    end
        
    it "shows the conversation between the sender and the recipient"
    context "when its a join request" do
      it "shows a an option to accept the join request"
      it "shows an option to reject the join request"
      it "shows an option to reply to the private message"
      ##when a join request is accepted, all other join requests are rejected
    end
  end

  describe "GET outgoing_messages" do
    let(:bob) { Fabricate(:user) }
    let(:message1) { Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id) }
    let(:message2) { Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "Did you get my message?", project_id: word_press.id) }
    let(:message3) { Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'm just writing to you again", project_id: word_press.id) }


    before do
      alice.update_columns(organization_id: huggey_bear.id)
      session[:user_id] = bob.id
    end

    it "shows the current user's sent messages sent messages" do
      get :outgoing_messages
      expect(bob.sent_messages).to eq([message1, message2, message3])
    end

    it "sets the @messages to the current user's sent messages" do
      get :outgoing_messages
      expect(assigns(:messages)).to eq(bob.sent_messages)
    end

    it "renders the sent messages template" do
      get :outgoing_messages
      expect(response).to render_template(:outgoing_messages)
    end
  end
end