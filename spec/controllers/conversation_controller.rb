require 'spec_helper'

describe ConversationController do
  describe "GET new" do
    it "sets the @conversation"
    it "sets the content of the conversation"
    it "shows a send button"
    it "sets the recipient's value"
    it "sets the sender's value"
  end

  describe "POST create" do
    it "redirects the current user to the show view of the conversation"
    it "alerts the recipient that he/she has received a message"
  end

  describe "GET show" do
    it "it renders the show template"
    it "sets the @conversation"
    it "shows the private messages' content between the recipient and the sender"
    it "shows the date and time of sent of each private message"
  end
end