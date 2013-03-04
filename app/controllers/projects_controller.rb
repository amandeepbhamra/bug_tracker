class ProjectsController < ApplicationController
  
  before_filter :validate_user_exits
  before_filter :validate_project, :only => [:show, :validate_allowed_users, :add_member_project]
 
  # GET /projects
  # GET /projects.json
  def index
    @projects = @user.projects
    @assigned_projects = @user.assigned_projects
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = @user.projects.find(params[:id])
    @project_members = @project.members
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = @user.projects.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = @user.projects.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = @user.projects.build(params[:project])
    respond_to do |format|
      if @project.save
        @project.members = [@user]
        format.html { redirect_to @user, notice: 'Project was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = @user.projects.find(params[:id])
      respond_to do |format|
      if @project.update_attributes(params[:project]) 
        format.html { redirect_to @user, notice: 'Project was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = @user.projects.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :no_content }
    end
  end

  # For validating users to be addable as member in Project #
  def validate_allowed_users 
    @allowed_users = User.allowed_users(current_user)
  end

  # For Adding user as member in project #
  def add_member_project 
    @project.members.clear
    
    for user in params[:project][:user_ids]
      Project.add_members_to_project(current_user,user,@project)
    end
    @project.update_attributes(params[:members])
    redirect_to user_project_path(@user,@project), notice: "Members Added"
  end

  private

  # Filter To check whether user exits or not #
  def validate_user_exits 
    @user = User.find_by_id(params[:user_id])
    redirect_to root_path if @user.nil?
  end
  
  # Filter For Finding project id #
  def validate_project 
    @project = Project.find_by_id(params[:id])
  end
end
