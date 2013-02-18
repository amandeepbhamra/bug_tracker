class Ticket < ActiveRecord::Base
  attr_accessible :description, :title

  belongs_to :project
  belongs_to :user

end
