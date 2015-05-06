class AddAssignedToToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :assigned_to, :integer
  end
end
