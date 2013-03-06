class Ticket < ActiveRecord::Base
  attr_accessible :description, :title, :project_id, :document, :status, :assigned_to

  belongs_to :project
  belongs_to :user
  
  has_many :comments, :dependent => :destroy

  validates :title, :description, :status, :presence => true 

  has_attached_file :document, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  define_index do
    indexes :title
    indexes :description
  end

  TICKET_STATES = {1=> "New", 2 => "Open", 3 => "Hold", 4 => "Resolved", 5 => "Closed"}

  def ticket_status
  	TICKET_STATES[status]
  end
  
  def self.ticket_status_array
  	TICKET_STATES.to_a.sort
  end

  def self.validate_document_image(document)
    if (document.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
      true  
    end
  end
end
