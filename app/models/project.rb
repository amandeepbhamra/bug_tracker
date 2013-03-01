class Project < ActiveRecord::Base
  attr_accessible :description, :name, :user_ids

  has_many :tickets
  has_and_belongs_to_many :members, :class_name => "User", :uniq => true
  belongs_to :user

  validates :name, :description, :presence => true 

  USER_ROLES = { 1=> "Manager", 2 => "Member" }

  def user_role
    USER_ROLES[user_role]
  end
  
  def self.ticket_status_array
    USER_ROLES.to_a.sort
  end

  def self.add_members_to_project(current_user,user,project)
  	@member = User.find_by_id(user)
    project.members << (@member)
    Notify.delay(queue: "member_added_notification_to_admin", priority: 3).member_added_notification_to_admin(current_user, project, @member)
    Notify.delay(queue: "notification_to_member_tvalidate_allowed_usershat_added", priority: 3).notification_to_member_that_added(current_user, project, @member)
  end
 
end
