class Charge::MonthlyCodeDownlinkReport < ActiveRecord::Base
  attr_accessor :from_date, :end_date

  DAILY = "日明细"
  MONTHLY = "月明细"
  TOTAL = '合计'

  def search
    conditions = {
      report_date: @from_date..@end_date
    }
    conditions[:code_name] = self.code_name if self.code_name.present?
    daily_results = self.class.where(conditions).where(report_type: DAILY).order(:report_date).group_by {|res| res.link_id }
    total_results = self.class.where(conditions).where(report_type: TOTAL).order(:report_date)

    results = []
    total_results.each do |total_res|
      results << {
        total: total_res,
        daily: daily_results[total_res.link_id]
      }
    end
    results
  end

  def link_id
    "#{report_date.year}-#{report_date.month}-#{code_name}"
  end
end
