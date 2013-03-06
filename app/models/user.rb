class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
  :trackable, :validatable, :confirmable, :token_authenticatable, :invitable

  attr_accessible :name, :email, :password, :password_confirmation, 
  :remember_me, :photo
  
  has_many :projects, :dependent => :destroy
  has_many :tickets, :through => :projects
  has_many :roles, :through => :projects, :uniq => true
  
  has_and_belongs_to_many :assigned_projects, :class_name => "Project", :uniq => true, 
                          :join_table => "projects_users"
  
  accepts_nested_attributes_for :roles                        
  validates :name, :presence => true , :if => lambda{|a| !a.new_record?}
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  def self.allowed_users(current_user)
    invitation_accepted.find_all_by_invited_by_id(current_user)
  end
  
  def self.not_allowed_users(current_user)
    invitation_not_accepted.find_all_by_invited_by_id(current_user)
  end
  
  USER_ROLES = { 1=> "Manager", 2 => "Member" }

  def user_role
    USER_ROLES[user_role]
  end
  
  def self.user_role_array
    USER_ROLES.to_a.sort
  end
end
