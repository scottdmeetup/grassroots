class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
  end

  def index
    @organizations = Organization.all
  end
end