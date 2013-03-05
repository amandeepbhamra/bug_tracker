class Role < ActiveRecord::Base
  attr_accessible :project_id, :user_role, :user_id

  belongs_to :project
  belongs_to :user
  
end
