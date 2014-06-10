class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
  end

  def index
    @organizations = Organization.all
  end

  def search
    filter = {cause: params[:cause]} if params[:cause]
    
    if filter != nil
      @results = Organization.where(filter).to_a
      @results.sort! {|x,y| x.name <=> y.name }
    end 
  end

private

  def organization_params
    params.require(:organization).permit(:name, :date_of_incorporation, 
      :ein, :street1, :street2, :city, :state_abbreviation, :zip, :cause, 
      :contact_number, :contact_email, :mission_statement, :goal, :user_id)
  end

end