class CreateProjectsUsersJoinTable < ActiveRecord::Migration
   def self.up
    create_table :projects_users, :id => false do |t|
        t.references :project
        t.references :user
    end
    add_index :projects_users, [:project_id, :user_id]
    add_index :projects_users, [:user_id, :project_id]
  end

  def self.down
    drop_table :projects_users
  end
end
