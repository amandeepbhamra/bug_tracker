class Attachment < ActiveRecord::Base
  
  attr_accessible :file, :file_content_type, :file_file_name, :file_file_size

  belongs_to :attachable, :polymorphic => true

  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  def self.validate_document_image(file)
    if (file.file_content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
      true  
    end
  end
end
