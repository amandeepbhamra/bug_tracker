class AddAttachmentDocumentToTickets < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.attachment :document
    end
  end

  def self.down
    drop_attached_file :tickets, :document
  end
end
