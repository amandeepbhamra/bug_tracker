class Comment < ActiveRecord::Base
  attr_accessible :commentor, :content, :ticket_id
end
