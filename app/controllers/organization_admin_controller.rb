class OrganizationAdminController < ApplicationController
  before_filter :ensure_admin

  def ensure_admin
    redirect_to user_path(current_user.id) unless current_user.organization_administrator
  end
end