class TicketsController < ApplicationController
  
  before_filter :validate_project, :only => [:index, :show, :new, :edit, :create, :update, :destroy]
  before_filter :validate_user
  before_filter :validate_ticket, :only => [:edit, :update, :destroy]
  before_filter :validate_just_ticket, :only => [:show]
  before_filter :search, :only => [:index, :view_all_tickets, :view_new_tickets, :view_open_tickets, :view_hold_tickets, :view_resolved_tickets, :view_closed_tickets]

  def index
    @project_tickets = @project.tickets.where("status = ? AND assigned_to = ?" , 2, current_user).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    if defined? params[:status]
      case params[:status]
        when 'assigned'
          @project_tickets = @project.tickets.where("assigned_to = ?" , current_user).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
        when 'all' 
          @project_tickets = @project.tickets.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
        when 'new' 
          @project_tickets = @project.tickets.where("status = ?" , 1).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
        when 'open' 
          @project_tickets = @project.tickets.where("status = ?" , 2).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
        when 'hold' 
          @project_tickets = @project.tickets.where("status = ?" , 3).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
        when 'resolved' 
          @project_tickets = @project.tickets.where("status = ?" , 4).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
        when 'closed' 
          @project_tickets = @project.tickets.where("status = ?" , 5).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
      end
    end
    
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
        Notify.notify_to_whom_ticket_is_assigned(@user, @project, @ticket).deliver unless @ticket.assigned_to.nil?
        format.html { redirect_to project_ticket_path(@project,@ticket), notice: 'Ticket was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        Notify.notify_to_whom_ticket_is_assigned(@user, @project, @ticket).deliver unless @ticket.assigned_to.nil?
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
    @search = Ticket.ransack(params[:q])
    @tickets_searched = @search.result
    @tickets_count = @tickets_searched.count
  end
  
  private

  # Filter To check whether user exits or not #
  def validate_user
    @user = current_user
    redirect_to current_user, notice: "User doesn't exists with this id." if @user.nil?
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

end
