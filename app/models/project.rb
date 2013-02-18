class Project < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :tickets
  belongs_to :user

end
