class OrganizationAdmin::ProjectsController < OrganizationAdminController
  def new
    @project = Project.new(organization_id: params[:organization_id])
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      organization = Organization.find_by(params[:id])
      current_user.projects << @project
      flash[:notice] = "You successfully created a project"
      redirect_to organization_path(current_user.organization.id)
    else
      render :new
    end
  end

private

  def project_params
    params.require(:project).permit(:title, :organization_id, :user_id, :description, :skills, :deadline)
  end

end