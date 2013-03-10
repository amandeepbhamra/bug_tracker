class Comment < ActiveRecord::Base
	attr_accessible :commentor, 
					:content, 
					:ticket_id,
					:attachments_attributes

  	has_many :attachments, 
  			:as => :attachable, 
  			:dependent => :destroy

  	belongs_to :user

  	accepts_nested_attributes_for :attachments, :allow_destroy => true

	validates :content, :commentor, :presence => true 

	def attachments_attributes=(attachments_attributes)
    	attachments_attributes.each do |attributes|
      		attachments.build(attributes)
    	end
  	end
end
