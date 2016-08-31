class Charge::MonthlyCodeDownlinkReportsController < ApplicationController
  before_action :sso_filter, :store_account_id_login
  layout "iframe"

  def index
    @report = Charge::MonthlyCodeDownlinkReport.new(report_params)
    @results = @report.search
    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

  private
  def secure?
    false
  end

  def report_params
    report_params = {}
    if params[:charge_monthly_code_downlink_report].present?
      report_params = params.require(:charge_monthly_code_downlink_report).permit(:from_date, :end_date, :code_name)
    end
    report_params[:from_date] = (parse_date(report_params[:from_date]) || Date.today - 3.months).at_beginning_of_month
    report_params[:end_date]  = (parse_date(report_params[:end_date]) || Date.today).at_end_of_month
    report_params
  end

  def parse_date(date_str)
    match_data = date_str.to_s.match(/(\d{4})[\/-](\d{2})/)
    return nil if match_data.nil?
    Date.parse(date_str)
  end

end
