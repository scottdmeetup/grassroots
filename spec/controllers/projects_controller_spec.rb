require 'spec_helper'

describe ProjectsController, :type => :controller do
  describe "GET index" do
    it "shows all of the projects on Grassroots that are, open" do
      word_press = Fabricate(:project, title: "WordPress Site", state: "open")
      logo = Fabricate(:project, title: "Huggey Bear Logo", state: "open")
      brochures = Fabricate(:project, title: "Schmancy Brochures", state: "open")
      web_development = Fabricate(:project, title: "Maintain Drupal Site")

      get :index
      expect(assigns(:projects)).to match_array([word_press, logo, brochures])
    end
  end

  describe "GET show" do
    it "shows a project" do
      word_press = Fabricate(:project, title: "WordPress Site")

      get :show, id: word_press
      expect(assigns(:project)).to eq(word_press)
    end
  end

  describe "GET search" do
    context "when using the checkbox filters" do
      it "redirects to the results page" do
        get :search
        expect(response).to render_template(:search)
      end
      it "shows only the projects within a certain skill set" do
        word_press = Fabricate(:project, title: "WordPress Site", skills: "web development")
        get :search, skills: word_press.skills

        expect(assigns(:results)).to eq([word_press])
      end
      it "shows the projects under a certain cause" do
        huggey_bear = Fabricate(:organization, cause: "animals")
        word_press = Fabricate(:project, title: "WordPress Site", skills: "web development", causes: "animals", organization_id: huggey_bear.id)
        get :search, causes: "animals"

        expect(assigns(:results)).to eq([word_press])
      end

      it "shows the projects with one or more submitted skill sets" do
        word_press = Fabricate(:project, title: "WordPress Site", skills: "web development")
        logo = Fabricate(:project, title: "Logo Redesign", skills: "graphic design")
        get :search, skills: [word_press.skills, logo.skills]
        
        expect(assigns(:results)).to eq([word_press, logo])
      end
    end
    context "when using the search bar" do
      it "sets the @results variable by search term" do
        word_press = Fabricate(:project, title: "WordPress Site", skills: "web development", description: "We need a new app....")
        logo = Fabricate(:project, title: "Logo Redesign", skills: "graphic design", description: "our logo needs a lot of work...")
        logo_2 = Fabricate(:project, title: "Nonprofit Logo", skills: "graphic design", description: "design work for the words...")
        get :search, search_term: "word"

        expect(assigns(:results)).to match_array([word_press, logo_2])
      end

      it "removes duplicate items in @results" do
        word_press = Fabricate(:project, title: "WordPress Site", skills: "web development", description: "We need a new wordpress app....")
        logo = Fabricate(:project, title: "Logo Redesign", skills: "graphic design", description: "our logo needs a lot of work...")
        logo_2 = Fabricate(:project, title: "Nonprofit Logo", skills: "graphic design", description: "design work for the words...")
        get :search, search_term: "word"

        expect(assigns(:results)).to match_array([word_press, logo_2])
      end
    end
  end
end