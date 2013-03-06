class UsersController < ApplicationController
  
  before_filter :validate_user, :only => [:show, :edit, :update, :assign_project_to_user, :list_of_invited_members]
  
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def edit
  end

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

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        Notify.delay(queue: "user_profile_update_notification", priority: 3).user_profile_update_notification(@user)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Action to show the list of members invited #
  def list_of_invited_members
    @user_invitation_accepted = User.allowed_users(current_user)
    @user_invitation_not_accepted = User.not_allowed_users(current_user)
  end

  
  private

  # Filter To check whether user exits or not #
  def validate_user 
    @user = User.find_by_id(params[:id])
    redirect_to current_user, notice: 'User not found.' if @user.nil?
  end
end
