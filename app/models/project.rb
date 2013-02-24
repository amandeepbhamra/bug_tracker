class Project < ActiveRecord::Base
  attr_accessible :description, :name, :user_ids

  has_many :tickets
  has_and_belongs_to_many :members, :class_name => "User", :uniq => true
  belongs_to :user

  validates :name, :description, :presence => true 
 
end
