class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.string :commentor
      t.integer :ticket_id, :null => false

      t.timestamps
    end
  end
end
