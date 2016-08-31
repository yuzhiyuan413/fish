# -*- encoding : utf-8 -*-
class CreateEworkConversionReports < ActiveRecord::Migration
  def change
    create_table :ework_conversion_reports do |t|
      t.date :report_date
      t.string :tag
      t.integer :app_activation
      t.integer :get_url
      t.float :get_url_ratio
      t.integer :download_jar
      t.float :download_jar_ratio
      t.integer :merge_jar
      t.float :merge_jar_ratio
      t.integer :launch_jar
      t.float :launch_jar_ratio
      t.integer :seed_active
      t.float :seed_active_ratio
      t.integer :seed_executed
      t.float :seed_executed_ratio

      t.timestamps
    end

    add_index :ework_conversion_reports, :report_date
    add_index :ework_conversion_reports, :tag
  end
end
