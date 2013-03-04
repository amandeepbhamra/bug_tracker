class AddUserRoleToProjectsUsers < ActiveRecord::Migration
  def change
    add_column :projects_users, :user_role, :integer, :null => false
  end
end
