class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
  end

  def index
    @organizations = Organization.all
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params.merge!(user_id: current_user.id))
    @organization.save
    current_user.update_columns(organization_id: @organization.id)
    redirect_to organization_path(@organization.id)
  end

private

  def organization_params
    params.require(:organization).permit(:name, :date_of_incorporation, 
      :ein, :street1, :street2, :city, :state_abbreviation, :zip, :cause, 
      :contact_number, :contact_email, :mission_statement, :goal, :user_id)
  end

end