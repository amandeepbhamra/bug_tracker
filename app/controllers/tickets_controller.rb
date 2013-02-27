class TicketsController < ApplicationController
  
  before_filter :validate_project
  before_filter :validate_user
  before_filter :tickets_count_by_status, :only => [:index, :view_new_tickets, :view_open_tickets, :view_hold_tickets, :view_resolved_tickets, :view_closed_tickets]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = @project.tickets
    @user_assigned_tickets = @user.tickets
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @ticket = @project.tickets.find(params[:id])
    @ticket_by_params = Ticket.find_by_id(params[:id])
    @comments = @ticket_by_params.comments
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /tickets/new
  # GET /tickets/new.json
  def new
    @ticket = @project.tickets.build
    respond_to do |format|
      format.html # new.html.erb
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
        Notify.delay(queue: "ticket_creation_notification", priority: 3, run_at: 2.minutes.from_now ).ticket_creation_notification(@user, @project, @ticket)
        Notify.delay(queue: "notify_to_whom_ticket_is_assigned", priority: 2, run_at: 2.minutes.from_now ).notify_to_whom_ticket_is_assigned(@user, @project, @ticket)
        format.html { redirect_to user_project_tickets_path(@user, @project), notice: 'Ticket was successfully created.' }
      else
        format.html { render action: "new" }
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
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket = @project.tickets.find(params[:id])
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to user_project_tickets_path(@user, @project), notice: "Ticket destroyed" }
    end
  end

  def search
    @tickets_searched = Ticket.search(params[:search],:page => params[:page], :per_page => 10)
    @tickets_count = Ticket.search(params[:search]).count
  end
  
  def view_new_tickets
    @new_tickets = @project.tickets.find_all_by_status(1)
  end

  def view_open_tickets
    @open_tickets = @project.tickets.find_all_by_status(2)
  end
  
  def view_hold_tickets
    @hold_tickets = @project.tickets.find_all_by_status(3)
  end
  
  def view_resolved_tickets
    @resolved_tickets = @project.tickets.find_all_by_status(4)
  end

  def view_closed_tickets
    @closed_tickets = @project.tickets.find_all_by_status(5)
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

  def tickets_count_by_status
    @all_tickets_count = @project.tickets.count
    @new_tickets_count = @project.tickets.find_all_by_status(1).count
    @open_tickets_count = @project.tickets.find_all_by_status(2).count
    @hold_tickets_count = @project.tickets.find_all_by_status(3).count
    @resolved_tickets_count = @project.tickets.find_all_by_status(4).count
    @closed_tickets_count = @project.tickets.find_all_by_status(5).count
  end
end
