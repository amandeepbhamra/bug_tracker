class Project < ActiveRecord::Base
  attr_accessible :description, 
                  :title, 
                  :user_ids

  has_many  :tickets, 
            :dependent => :destroy,
            :order => 'created_at DESC'
  
  has_and_belongs_to_many :members, 
                          :class_name => "User", 
                          :uniq => true, 
                          :join_table => "projects_users"
  
  belongs_to :user

  validates :title, :presence => true 

  # For adding/removing members in a project #
  def self.add_members_to_project(current_user,user,project)
  	@member = User.find_by_id(user)
    project.members << [current_user] <<(@member)
    Notify.notification_to_member_that_added(current_user, project, @member).deliver
  end
  
  # For getting just the title of the project #
  def self.project(project)
    find_by_id(project) unless project.nil?
  end

  # For getting open tickets count with respect to a user #
  def self.open_tickets_count(project,user)
    project.tickets.where("status = ? And assigned_to = ?" , 2, user).count
  end
end

