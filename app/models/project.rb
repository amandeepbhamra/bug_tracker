class Project < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :tickets
  has_and_belongs_to_many :members, :class_name => "User"
  belongs_to :user

end
