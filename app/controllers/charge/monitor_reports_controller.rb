# -*- encoding : utf-8 -*-
class Charge::MonitorReportsController < ApplicationController
  before_action :sso_filter, :store_account_id_login
  def index
    params.permit!
    @charge_monitor_report = Charge::MonitorReport.new(params[:charge_monitor_report])
    respond_to do |format|
      format.html do
        render layout: "iframe"
      end
      format.json do
        daily_reports = @charge_monitor_report.current_daily_reports
        hourly_reports = @charge_monitor_report.current_hourly_reports
        hourly_request_reports = @charge_monitor_report.current_hourly_for_request_reports
        hourly_reports = @charge_monitor_report.merge_hourly_reports(hourly_reports,hourly_request_reports)
        daily_sum_record = @charge_monitor_report.daily_sum_record(daily_reports)
        hourly_sum_record = @charge_monitor_report.hourly_sum_record(hourly_reports)
        hourly_comparison = @charge_monitor_report.comparison(hourly_reports)
        json_data = {}
        json_data[:body] = daily_reports
        json_data[:other_body] = hourly_reports
        json_data[:foot] = [ daily_sum_record ]
        json_data[:other_foot] = [ hourly_sum_record ]

        if hourly_comparison.present?
          json_data[:hourly_comparison] = hourly_comparison
        end
        render json: json_data
      end
    end
  end

  private
    def secure?
      false
    end

end
