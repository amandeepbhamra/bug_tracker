class Attachment < ActiveRecord::Base
  
  attr_accessible :file, :file_content_type, :file_file_name, :file_file_size

  belongs_to :attachable, :polymorphic => true

  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
