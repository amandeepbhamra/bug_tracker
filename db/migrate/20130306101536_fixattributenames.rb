class Fixattributenames < ActiveRecord::Migration
  def change
    rename_column :users, :username, :name
    rename_column :projects, :name, :title
  end
end
