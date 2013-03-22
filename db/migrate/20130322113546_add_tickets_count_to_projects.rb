class AddTicketsCountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :tickets_count, :integer, :default => 0
    
    Project.reset_column_information
    Project.all.each do |p|
      p.update_attribute :tickets_count, p.tickets.length
    end
  end
end
