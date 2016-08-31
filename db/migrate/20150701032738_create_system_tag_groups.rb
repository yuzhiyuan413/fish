# -*- encoding : utf-8 -*-
class CreateSystemTagGroups < ActiveRecord::Migration
  def change
    create_table :system_tag_groups do |t|
      t.string :name
      t.string :regexp
      t.boolean :is_sum_group
      t.string :desc

      t.timestamps
    end
  end
end
