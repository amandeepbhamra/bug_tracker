class Fixinvitationsattributesname < ActiveRecord::Migration
  def change
  	rename_column :invitations, :invited_by, :invited_by_id
  end
  
end
