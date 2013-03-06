class CommentsController < ApplicationController
  
  before_filter :validate_ticket
  
  def new
    @comment = @ticket.comments.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  def create
    @comment = @ticket.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to user_project_ticket_path(current_user,@ticket.project.id,@ticket), notice: 'Comment was successfully created.' }
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
end
