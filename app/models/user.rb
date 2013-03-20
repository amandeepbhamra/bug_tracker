class User < ActiveRecord::Base

  devise  :database_authenticatable, 
          :registerable, 
          :recoverable, 
          :rememberable, 
          :trackable, 
          :validatable, 
          :confirmable, 
          :token_authenticatable, 
          :invitable

  attr_accessible :name, 
                  :email, 
                  :password, 
                  :remember_me, 
                  :photo
  
  has_many  :projects, 
            :dependent => :destroy, 
            :order => 'created_at DESC'
  has_many  :tickets, 
            :through => :projects, 
            :order => 'created_at DESC'
  has_many  :roles, 
            :through => :projects, 
            :uniq => true
  has_many  :invitations, 
            :as => :invited_by,
            :dependent => :destroy,
            :foreign_key => "invited_by"
                       
  
  has_and_belongs_to_many :assigned_projects, 
                          :class_name => "Project", 
                          :uniq => true, 
                          :join_table => "projects_users", 
                          :order => 'created_at DESC'
  
  accepts_nested_attributes_for :roles                        
  
  validates :name,  :presence => true , 
                    :if => lambda{|a| !a.new_record?}
  validates_attachment_content_type :photo,
                                    :content_type => ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],
                                    :message => "Different error message",
                                    :if => lambda{|a| !a.new_record?}
  
  has_attached_file :photo, :styles => { :medium => "154x154>", :thumb => "38x38>" }, 
  :default_url => "/assets/users_sticker.png"

    
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

  def self.user_name(user)
    find_by_id(user).name unless user.nil?
  end

  def self.user_id(user)
    find_by_id(user).id unless user.nil?
  end

  def self.user(user)
    find_by_id(user) unless user.nil?
  end
  
end
