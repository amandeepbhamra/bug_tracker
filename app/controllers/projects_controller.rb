class ProjectsController < ApplicationController
  
  before_filter :validate_user_exits
  before_filter :vaildate_project_id
 
  # GET /projects
  # GET /projects.json
  def index
    @projects = @user.projects
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = @user.projects.find(params[:id])
    @project_members = @project_id.members
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

  def validate_user_exits # Filter To check whether user exits or not #
    @user = User.find_by_id(params[:user_id])
    redirect_to root_path if @user.nil?
  end
  
  def vaildate_project_id # Filter For Finding project id #
    @project_id = Project.find_by_id(params[:id])
  end

  def validate_allowed_users # For validating users to be addable as member in Project#
    @project_members = @project_id.members
    @user_invitation_accepted = User.invitation_accepted.find_all_by_invited_by_id(current_user)
  end
  
  def add_member_project # For Adding user as member in project #
    @project_id.members.clear
    for user in params[:project][:user_ids]
      @project_id.members << (User.find_by_id(user))
    end
    @project_id.update_attributes(params[:members])
    redirect_to @user, notice: "Members Added"
  end
end
