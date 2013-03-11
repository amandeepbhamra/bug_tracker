class TicketsController < ApplicationController
  
  before_filter :validate_project, :only => [:show, :new, :edit, :create, :update, :destroy]
  before_filter :validate_user
  before_filter :validate_ticket, :only => [:edit, :update, :destroy]
  before_filter :validate_just_ticket, :only => [:show,]
  before_filter :tickets_count_by_status, :only => [:index, :view_new_tickets, :view_open_tickets, :view_hold_tickets, :view_resolved_tickets, :view_closed_tickets]

  def index
    @tickets = Ticket.paginate(:page => params[:page], :per_page => 5).all
    @user_assigned_tickets = Ticket.paginate(:page => params[:page], :per_page => 5).find_all_by_assigned_to(current_user)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @comments = @ticket.comments
    @comment = Comment.new
    @comment.attachments.build
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @ticket = Ticket.new
    @project.tickets.build
    @ticket.attachments.build
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
  end

  def create
    @ticket = @project.tickets.build(params[:ticket])
    respond_to do |format|
      if @ticket.save
        Notify.delay(queue: "ticket_creation_notification", priority: 3, run_at: 2.minutes.from_now ).ticket_creation_notification(@user, @project, @ticket)
        Notify.delay(queue: "notify_to_whom_ticket_is_assigned", priority: 2, run_at: 2.minutes.from_now ).notify_to_whom_ticket_is_assigned(@user, @project, @ticket)
        format.html { redirect_to project_ticket_path(@project,@ticket), notice: 'Ticket was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to project_ticket_path(@project,@ticket), notice: 'Ticket was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to project_tickets_path(@project), notice: "Ticket destroyed" }
    end
  end

  # Action for search - Thinking sphinx #
  def search
    @tickets_searched = Ticket.search(params[:search],:page => params[:page], :per_page => 10)
    @tickets_count = Ticket.search(params[:search]).count
  end
  
  # Action to get list of all new tickets #
  def view_new_tickets
    @new_tickets = Ticket.paginate(:page => params[:page], :per_page => 5).find_all_by_status(1)
  end

  # Action to get list of all open tickets #
  def view_open_tickets
    @open_tickets = Ticket.paginate(:page => params[:page], :per_page => 5).find_all_by_status(2)
  end
  
  # Action to get list of all hold tickets #
  def view_hold_tickets
    @hold_tickets = Ticket.paginate(:page => params[:page], :per_page => 5).find_all_by_status(3)
  end
  
  # Action to get list of all resolved tickets #
  def view_resolved_tickets
    @resolved_tickets = Ticket.paginate(:page => params[:page], :per_page => 5).find_all_by_status(4)
  end

  # Action to get list of all closed tickets #
  def view_closed_tickets
    @closed_tickets = Ticket.paginate(:page => params[:page], :per_page => 5).find_all_by_status(5)
  end

  private

  # Filter To check whether user exits or not #
  def validate_user 
    @user = current_user
    redirect_to current_user, notice: 'User not found.' if @user.nil?
  end

  # Filter To check whether project exits or not #
  def validate_project
    @project = Project.find_by_id(params[:project_id])
    redirect_to current_user, notice: "Invalid Project" if @project.nil?
  end

  # Filter to get ticket #
  def validate_ticket
    @ticket = @project.tickets.find_by_id(params[:id])
    redirect_to current_user, notice: "Invalid Ticket" if @ticket.nil?
  end

  # Filter to get ticket #
  def validate_just_ticket
    @ticket = Ticket.find_by_id(params[:id])
    redirect_to current_user, notice: "Invalid Ticket" if @ticket.nil?
  end

  # Filter to get count tickets ordered by status for respective actions #
  def tickets_count_by_status
    @all_tickets_count = @user.tickets.count
    @new_tickets_count = @user.tickets.find_all_by_status(1).count
    @open_tickets_count = @user.tickets.find_all_by_status(2).count
    @hold_tickets_count = @user.tickets.find_all_by_status(3).count
    @resolved_tickets_count = @user.tickets.find_all_by_status(4).count
    @closed_tickets_count = @user.tickets.find_all_by_status(5).count
  end
end
