class RemoveColumnOfDocumentsFromTickets < ActiveRecord::Migration
  	def self.up
  		remove_column :tickets, :document_file_name
  		remove_column :tickets, :document_content_type
  		remove_column :tickets, :document_file_size
  		remove_column :tickets, :document_updated_at
  	end

  	def self.down
  		add_column :tickets, :document_file_name
  		add_column :tickets, :document_content_type
  		add_column :tickets, :document_file_size
  		add_column :tickets, :document_updated_at
  	end
end
