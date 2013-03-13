class Project < ActiveRecord::Base
  attr_accessible :description, 
                  :title, 
                  :user_ids

  has_many  :tickets, 
            :dependent => :destroy,
            :order => 'created_at DESC'
  has_many  :roles, 
            :dependent => :destroy
  
  has_and_belongs_to_many :members, 
                          :class_name => "User", 
                          :uniq => true, 
                          :join_table => "projects_users"
  
  belongs_to :user

  accepts_nested_attributes_for :roles
  
  validates :title, :description, :presence => true 

  def self.add_members_to_project(current_user,user,project)
  	@member = User.find_by_id(user)
    project.members << [current_user] <<(@member)
    Notify.member_added_notification_to_admin(current_user, project, @member).deliever
    Notify.notification_to_member_that_added(current_user, project, @member).deliever
  end
 
end

