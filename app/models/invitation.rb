class Invitation < ActiveRecord::Base
  attr_accessible :invited_by_id, :user_id

  belongs_to :user

  validates_uniqueness_of :invited_by_id, :scope => :user_id
  
  def self.invited_users(invited_by_id)
    find_all_by_invited_by_id(invited_by_id)
  end

end
