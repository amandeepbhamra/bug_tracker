class Ticket < ActiveRecord::Base
  attr_accessible :description, :title, :project_id, :document, :status

  belongs_to :project
  belongs_to :user

  has_attached_file :document, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  TICKET_STATES = {1=> "New", 2 => "Open", 3 => "Hold", 4 => "Resolved", 5 => "Closed"}

  def ticket_status
  	TICKET_STATES[status]
  end
  
  def self.ticket_status_array
  	TICKET_STATES.to_a.sort
  end
end
