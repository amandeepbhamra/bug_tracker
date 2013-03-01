class AddUserRoleToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :user_role, :integer
  end
end
