# -*- encoding : utf-8 -*-
class CreateMedians < ActiveRecord::Migration
  def change
    create_table :medians do |t|
      t.string :name
      t.string :median_ratio2
      t.string :median_ratio3
      t.string :median_ratio7
      t.string :median_ratio15
      t.string :median_ratio30

      t.timestamps
    end
  end
end
