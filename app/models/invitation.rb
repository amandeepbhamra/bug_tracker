class Invitation < ActiveRecord::Base
  attr_accessible :invited_by, :user_id

  belongs_to :user

  validates_uniqueness_of :invited_by, :scope => :user_id
  
end
