class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :link_id
      t.string :link_type
      t.integer :function_id, :null => false
      t.integer :subsystem_id, :null => false
      t.integer :status, :null => false
      t.text :operates
      t.integer :sort
    end
  end

  def self.down
    drop_table :permissions
  end
end
