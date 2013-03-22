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
  
  validates :title, :presence => true 

  def self.add_members_to_project(current_user,user,project)
  	@member = User.find_by_id(user)
    project.members << [current_user] <<(@member)
    Notify.notification_to_member_that_added(current_user, project, @member).deliver
  end
  
  def self.project_title(project)
    find_by_id(project).title unless project.nil?
  end

  def self.open_tickets_count(project,user)
    project.tickets.where("status = ? And assigned_to = ?" , 2, user).count
  end
end

