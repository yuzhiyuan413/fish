module Charge::MonthlyCodeDownlinkReportsHelper
  def downlink_code_names
    Charge::MonthlyCodeDownlinkReportGenerator::CODES.collect {|code| code[:code_name]}
  end
end
