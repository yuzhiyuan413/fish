# -*- encoding : utf-8 -*-
class CreateEworkConversionMedians < ActiveRecord::Migration
  def change
    create_table :ework_conversion_medians do |t|
      t.string :name
      t.float :get_url_ratio
      t.float :download_jar_ratio
      t.float :merge_jar_ratio
      t.float :launch_jar_ratio
      t.float :seed_executed_ratio
      t.float :seed_active_ratio

      t.timestamps
    end
  end
end
