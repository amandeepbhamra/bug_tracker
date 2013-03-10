class Ticket < ActiveRecord::Base
  attr_accessible :description, 
                  :title, 
                  :project_id, 
                  :status, 
                  :assigned_to, 
                  :attachments_attributes
      

  has_many  :attachments, 
            :as => :attachable, 
            :dependent => :destroy
  has_many  :comments, 
            :dependent => :destroy

  belongs_to :project
  belongs_to :user
  
  validates :title, :description, :status, :presence => true 

  accepts_nested_attributes_for :attachments, :allow_destroy => true

  define_index do
    indexes :title
    indexes :description
  end

  def attachments_attributes=(attachments_attributes)
    attachments_attributes.each do |attributes|
      attachments.build(attributes)
    end
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
