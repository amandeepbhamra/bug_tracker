class UsersController < ApplicationController
  
  before_filter :validate_user, :only => [:home, :show, :edit, :update, :assign_project_to_user, :list_of_invited_members]
  
  # home page action for showing user the assigned projects #
  def home
    @user_tickets = @user.tickets.paginate(:page => params[:page], :per_page => 5)
  end

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

  private

  # Filter To check whether user exits or not #
  def validate_user 
    @user = current_user
    redirect_to current_user, notice: 'User not found.' if @user != current_user
  end
end
