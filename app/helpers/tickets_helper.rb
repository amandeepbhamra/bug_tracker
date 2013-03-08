module TicketsHelper
	def add_attachment_link(name) 
	    link_to_function(name) do |ticket| 
	      	ticket.insert_html :bottom, :attachments, :partial => 'attachment', :object => Attachment.new 
	    end 
  	end
end
