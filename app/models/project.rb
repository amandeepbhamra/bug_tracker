class Project < ActiveRecord::Base
  attr_accessible :description, :name, :user_ids

  has_many :tickets
  has_many :roles
  
  has_and_belongs_to_many :members, :class_name => "User", :uniq => true, :join_table => "projects_users"
  
  belongs_to :user

  accepts_nested_attributes_for :roles
  
  validates :name, :description, :presence => true 

  def self.add_members_to_project(current_user,user,project)
  	@member = User.find_by_id(user)
    project.members << (@member)

    Notify.delay(queue: "member_added_notification_to_admin", priority: 3).member_added_notification_to_admin(current_user, project, @member)
    Notify.delay(queue: "notification_to_member_tvalidate_allowed_usershat_added", priority: 3).notification_to_member_that_added(current_user, project, @member)
  end
 
end
