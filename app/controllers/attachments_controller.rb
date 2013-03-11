class AttachmentsController < ApplicationController

	before_filter :load_attachable

	def index
  		@attachable = find_attachable
  		@attachments = @attachable.attachments
	end

	def new
		@attachment = @attachable.attachments.build
	end

	def create
  		@attachable = find_attachable
  		@attachment = @attachable.attachments.build(params[:comment])
  		if @attachment.save
    		redirect_to :id => nil
  		else
    		render :action => 'new'
  		end
	end

	private

	def load_attachable
		klass = [Ticket, Comment].detect { |c| params["#{c.name.underscore}_id"]}
		@attachable = klass.find(params["#{klass.name.underscore}_id"])
	end
end
