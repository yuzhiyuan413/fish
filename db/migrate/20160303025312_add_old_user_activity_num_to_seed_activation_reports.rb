# -*- encoding : utf-8 -*-
class AddOldUserActivityNumToSeedActivationReports < ActiveRecord::Migration
  def change
    add_column :seed_activation_reports, :old_user_activity_num, :integer
  end
end
