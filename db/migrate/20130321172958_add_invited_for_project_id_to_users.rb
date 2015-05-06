class AddInvitedForProjectIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invited_for_project_id, :integer
  end
end
