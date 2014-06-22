require 'spec_helper'

describe CategoriesController, :type => :controller do
  describe "GET show" do
    let!(:uncategorized) {Fabricate(:category, name: "Uncategorized")}
    let!(:web_development) {Fabricate(:category, name: "Web Development")}

    it "renders the show template" do
      get :show, id: web_development.id
      expect(response).to render_template(:show)
    end

    it "sets the @category" do
      get :show, id: web_development.id
      expect(assigns(:category)).to be_instance_of(Category)
    end
  end
end
