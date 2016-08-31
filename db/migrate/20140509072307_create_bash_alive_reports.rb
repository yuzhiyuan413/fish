# -*- encoding : utf-8 -*-
class CreateBashAliveReports < ActiveRecord::Migration
  def change
    create_table :bash_alive_reports do |t|
    	t.string :tag
    	t.integer :activation_num
    	t.integer :stay_alive2
    	t.integer :stay_alive3
    	t.integer :stay_alive7
    	t.integer :stay_alive15
    	t.integer :stay_alive30
    	t.date :report_time
      t.timestamps
    end
  end
end
