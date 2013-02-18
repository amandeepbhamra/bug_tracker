class Ticket < ActiveRecord::Base
  attr_accessible :description, :title, :project_id, :document

  belongs_to :project
  belongs_to :user

  has_attached_file :document, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
