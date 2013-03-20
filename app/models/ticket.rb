class Ticket < ActiveRecord::Base
  attr_accessible :description, 
                  :title, 
                  :project_id, 
                  :status, 
                  :assigned_to, 
                  :attachments_attributes

  has_many  :attachments, 
            :as => :attachable, 
            :dependent => :destroy,
            :order => 'created_at DESC'
  has_many  :comments, 
            :dependent => :destroy,
            :order => 'created_at DESC'

  belongs_to :project
  belongs_to :user
  
  validates :title, :status, :presence => true 

  accepts_nested_attributes_for :attachments, :allow_destroy => true
  
  TICKET_STATES = {1=> "New", 2 => "Open", 3 => "Hold", 4 => "Resolved", 5 => "Closed"}

  def ticket_status
  	TICKET_STATES[status]
  end
  
  def self.ticket_status_array
  	TICKET_STATES.to_a.sort
  end

  
end
