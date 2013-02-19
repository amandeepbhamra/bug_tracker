class Ticket < ActiveRecord::Base
  attr_accessible :description, :title, :project_id, :document

  belongs_to :project
  belongs_to :user

  has_attached_file :document, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  Ticket_status = {1=> "New", 2 => "Open", 3 => "Hold", 4 => "Resolved", 5 => "Closed"}
end
