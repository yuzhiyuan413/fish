module MonthlyCodeAliveReportHelper
  def service_providers_options
    Charge::MonthlyCodeAliveReport.select(:sp_id).distinct.collect(&:sp_id)
  end
end