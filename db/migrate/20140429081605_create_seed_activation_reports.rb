# -*- encoding : utf-8 -*-
class CreateSeedActivationReports < ActiveRecord::Migration
  def change
    create_table :seed_activation_reports do |t|
    	t.string :partner
    	t.string :tag
    	t.integer :seed_activation_num
    	t.integer :panda_activation_num
    	t.integer :old_user_active_num
    	t.integer :old_user_lose_num
    	t.integer :bash_activation_num
    	t.float :bash_activation_ratio
    	t.integer :signature_num
    	t.float :signature_ratio
    	t.date :report_time
      t.timestamps
    end
    add_index :seed_activation_reports, :report_time
    add_index :seed_activation_reports, :tag
  end
end
