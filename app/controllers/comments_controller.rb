class CommentsController < ApplicationController
  
  before_filter :validate_ticket
  before_filter :validate_user

  def new
    @comment = Comment.new
    @ticket.comments.build
    @comment.attachments.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  def create
    @comment = @ticket.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save
        Notify.notify_to_whom_ticket_is_assigned_about_comment(@ticket.assigned_to, @ticket.project.id, @ticket, @comment).deliver unless @ticket.assigned_to.nil?
        format.html { redirect_to project_ticket_path(@ticket.project.id, @ticket), notice: 'Comment was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  private

  #To validate that ticket exists or not#
  def validate_ticket 
    @ticket = Ticket.find_by_id(params[:ticket_id])
    redirect to @user, :notice => "Ticket not found" if @ticket.nil? 
  end
  
  # Filter To check whether user exits or not #
  def validate_user
    @user = current_user
    redirect_to current_user, notice: "User doesn't exists with this id." if @user.nil?
  end
end
