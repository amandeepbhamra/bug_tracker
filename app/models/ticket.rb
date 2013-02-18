class Ticket < ActiveRecord::Base
  attr_accessible :description, :title, :project_id

  belongs_to :project
  belongs_to :user

end
