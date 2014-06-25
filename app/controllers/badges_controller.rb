class BadgesController < ApplicationController
  
  def show
    @badge = Badge.find(params[:id])
  end

end