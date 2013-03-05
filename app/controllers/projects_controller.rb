class ProjectsController < ApplicationController
  
  before_filter :validate_user
  before_filter :validate_project, :only => [:show, :project_members, :add_member_project,:edit, :update, :destroy]
 
  def index
    @projects = @user.projects
    @assigned_projects = @user.assigned_projects
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @project_members = @project.members
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @project = @user.projects.build
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
  end

  def create
    @project = @user.projects.build(params[:project])
    respond_to do |format|
      if @project.save
        @project.members = [current_user]
        format.html { redirect_to user_project_path(@user,@project), notice: 'Project was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update_attributes(params[:project]) 
        format.html { redirect_to user_project_path(@user,@project), notice: 'Project was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to user_projects_path(@user), notice: 'Project was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # For validating users to be addable as member in Project #
  def project_members
    @allowed_users = User.allowed_users(current_user)
  end

  # For Adding user as member in project #
  def add_member_project 
    @project.members.clear
    if defined? params[:project][:user_ids]
      for user in params[:project][:user_ids] 
        Project.add_members_to_project(current_user, user, @project)
      end
    else
      @project.members = [current_user]
    end

    @project.update_attributes(params[:members])
    redirect_to user_project_path(@user,@project), notice: "Members Added"
  end

  private

  # Filter To check whether user exits or not #
  def validate_user
    @user = User.find_by_id(params[:user_id])
    redirect_to current_user, notice: "User doesn't exists with this id." if @user.nil?
  end
  
  # Filter For Finding project id #
  def validate_project 
    @project = @user.projects.find_by_id(params[:id])
    redirect_to @user, notice: 'No projects found with this id.' if @project.nil?
  end
end
