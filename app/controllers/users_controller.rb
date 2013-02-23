class UsersController < ApplicationController
  
  before_filter :validate_user, :only => [:show, :edit, :update, :assign_project_to_user]
  
  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    raise "hello"
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def validate_user # to check whether user is present or not #
    @user = User.find_by_id(params[:id])
    if @user.nil?
      @user = current_user
    end
  end
  
  def list_of_invited_members
    @user_invitation_accepted = User.invitation_accepted.find_all_by_invited_by_id(current_user)
    @user_invitation_not_accepted = User.invitation_not_accepted.find_all_by_invited_by_id(current_user)
  end
end
