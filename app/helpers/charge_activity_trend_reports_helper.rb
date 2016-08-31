# -*- encoding : utf-8 -*-
module ChargeActivityTrendReportsHelper

  def month_header day_header
    tbl_header = {}
    month_nums = day_header.map(&:month).compact
    month_nums.uniq.each do |m|
      tbl_header[m] = month_nums.count(m)
    end
    tbl_header
  end
end
