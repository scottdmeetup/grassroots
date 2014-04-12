require 'spec_helper'

describe ProjectsController do
  describe "GET index" do
    it "shows all of the projects on Grassroots" do
      word_press = Fabricate(:project, title: "WordPress Site")
      logo = Fabricate(:project, title: "Huggey Bear Logo")
      brochures = Fabricate(:project, title: "Schmancy Brochures")
      web_development = Fabricate(:project, title: "Maintain Drupal Site")

      get :index
      expect(assigns(:projects)).to match_array([word_press, logo, brochures, web_development])
    end
  end

  describe "GET show" do
    it "shows a project" do
      word_press = Fabricate(:project, title: "WordPress Site")

      get :show, id: word_press
      expect(assigns(:project)).to eq(word_press)
    end
  end
end