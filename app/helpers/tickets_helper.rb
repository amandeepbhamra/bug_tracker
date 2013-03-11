module TicketsHelper
	def fields_for_attachment(attachment, &block)
  		prefix = attachment.new_record? ? 'new' : 'existing'
  		fields_for("ticket[#{prefix}_attachment_attributes][]", attachment, &block)
	end

	def add_attachment_link(name) 
  		link_to_function(name) do |attachment| 
		    attachment.insert_html :bottom, :attachments, :partial => 'attachment', :object => Attachment.new 
  end 
end 

end
