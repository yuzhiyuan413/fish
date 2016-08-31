# -*- encoding : utf-8 -*-
class AddColumnSeedActiveAidRatioToEworkConversionMedians < ActiveRecord::Migration
  def change
    add_column :ework_conversion_medians, :seed_active_aid_ratio, :float
    add_column :ework_conversion_medians, :seed_executed_aid_ratio, :float
  end
end
