# -*- encoding : utf-8 -*-
module SeedActivitySituationReportsHelper
  def activity_ratio dividend, divisor
    "#{number_with_delimiter(dividend)}" + " | "+
    "#{number_to_percentage((dividend.to_f/divisor.to_f)*100, :precision => 2)}"
  end
end
