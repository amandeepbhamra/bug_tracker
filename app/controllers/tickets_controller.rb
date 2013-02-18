class TicketsController < ApplicationController
  
  before_filter :validate_user
  before_filter :validate_project  


  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = @project.tickets

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @ticket = @project.tickets.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket }
    end
  end

  # GET /tickets/new
  # GET /tickets/new.json
  def new
    @ticket = @project.tickets.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ticket }
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = @project.tickets.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = @project.tickets.build(params[:ticket])
    
    respond_to do |format|
      if @ticket.save
        format.html { redirect_to user_project_tickets_path(@user, @project), notice: 'Ticket was successfully created.' }
        format.json { render json: @ticket, status: :created, location: @ticket }
      else
        format.html { render action: "new" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.json
  def update
    @ticket = @project.tickets.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to user_project_tickets_path(@user, @project), notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket = @project.tickets.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to user_project_tickets_path(@user, @project) }
      format.json { head :no_content }
    end
  end

  def validate_user
    @user = User.find_by_id(params[:user_id])
    @user =current_user if @user.nil?
  end

  def validate_project
    @project = Project.find_by_id(params[:project_id])
    if @project.nil?
      redirect_to @user, notice: "Invalid Project"
    end
  end

end
