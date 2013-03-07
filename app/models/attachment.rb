class Attachment < ActiveRecord::Base
  
  attr_accessible :file

  belongs_to :attachable, :polymorphic => true

  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
