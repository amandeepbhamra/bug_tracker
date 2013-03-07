class Comment < ActiveRecord::Base
	attr_accessible :commentor, :content, :ticket_id

  	has_many :attachments, :as => :attachable

  	belongs_to :user

	validates :content, :commentor, :presence => true 
end
