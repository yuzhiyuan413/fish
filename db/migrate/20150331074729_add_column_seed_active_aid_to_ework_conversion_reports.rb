# -*- encoding : utf-8 -*-
class AddColumnSeedActiveAidToEworkConversionReports < ActiveRecord::Migration
  def change
    add_column :ework_conversion_reports, :seed_active_aid, :integer
    add_column :ework_conversion_reports, :seed_active_aid_ratio, :float
    add_column :ework_conversion_reports, :seed_executed_aid, :integer
    add_column :ework_conversion_reports, :seed_executed_aid_ratio, :float
  end
end
