class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
  :trackable, :validatable, :confirmable, :token_authenticatable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, 
  :remember_me, :photo
  
  has_many :projects
  has_many :tickets, :through => :projects
  has_and_belongs_to_many :assigned_projects , :class_name => "Project", :uniq => true

  #validates :username, :presence => true , :if => lambda{|a| !a.new_record?}
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  def self.allowed_users(current_user)
    invitation_accepted.find_all_by_invited_by_id(current_user)
  end
  def self.not_allowed_users(current_user)
    invitation_not_accepted.find_all_by_invited_by_id(current_user)
  end
end
