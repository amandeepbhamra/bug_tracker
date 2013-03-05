class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :project_id, :null => false
      t.integer :user_role, :null => false
    end
  end
end
