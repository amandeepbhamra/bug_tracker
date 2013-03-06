class RolesController < ApplicationController
  
  before_filter :validate_project
  before_filter :validate_user
  before_filter :validate_project_members
  
  def new
    @role = @project.roles.build
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @role = @project.roles.find(params[:id])
  end

  def create
    @role = @project.roles.build(params[:role])
    respond_to do |format|
      if @role.save
        format.html { redirect_to user_project_path(@user, @project), notice: 'Role assigned' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @role = @project.roles.find(params[:id])
    respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to user_project_path(@user, @project), notice: 'Role assigned' }
      else
        format.html { render action: "new" }
      end
    end
  end

  private

  def validate_user 
    @user = User.find_by_id(params[:user_id])
    @user = current_user if @user.nil?
  end

  def validate_project
    @project = Project.find_by_id(params[:project_id])
    redirect_to @user, notice: "Invalid Project" if @project.nil?
  end

  # For validating project members to be assigned roles #
  def validate_project_members 
    @project_members = @project.members
  end
end
