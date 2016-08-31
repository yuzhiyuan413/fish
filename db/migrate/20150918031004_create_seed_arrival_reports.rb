# -*- encoding : utf-8 -*-
class CreateSeedArrivalReports < ActiveRecord::Migration
  def change
    create_table :seed_arrival_reports do |t|
      t.date :report_date
      t.string :tag
      t.integer :seed_activation
      t.integer :seed_active
      t.integer :seed_executing
      t.integer :seed_executied
      t.integer :seed_successed
      t.integer :seed_installed
      t.integer :seed_started
      t.integer :seed_failed
      t.integer :seed_v8_exists
      t.integer :seed_v9_exists
      t.integer :v9_activity
      t.float :seed_active_ratio
      t.float :seed_executing_ratio
      t.float :seed_executied_ratio
      t.float :seed_successed_ratio
      t.float :seed_installed_ratio
      t.float :seed_started_ratio
      t.float :seed_failed_ratio
      t.float :seed_v8_exists_ratio
      t.float :seed_v9_exists_ratio
      t.float :v9_activity_ratio

      t.timestamps
    end
    add_index :seed_arrival_reports, :report_date
    add_index :seed_arrival_reports, :tag
  end
end
