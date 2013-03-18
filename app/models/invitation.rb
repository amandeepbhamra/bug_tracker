class Invitation < ActiveRecord::Base
  attr_accessible :invited_by, :user_id

  belongs_to :user
end
