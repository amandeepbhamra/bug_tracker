class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :invited_by, :null => false
      t.integer :user_id, :null => false
    end
  end
end
