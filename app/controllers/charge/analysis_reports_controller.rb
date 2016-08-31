
# -*- encoding : utf-8 -*-
class Charge::AnalysisReportsController < ApplicationController
  before_action :sso_filter, :store_account_id_login
  # GET /charge/analysis_reports
  # GET /charge/analysis_reports.json
  def index
    params.permit!
    @charge_analysis_report = Charge::AnalysisReport.new(params[:charge_analysis_report])
    @charge_analysis_report.code_union_name_flag ||= true
    @charge_analysis_report.report_date_flag ||= true
    @charge_analysis_report.start_date ||= Date.today.to_s
    @charge_analysis_report.end_date ||= Date.today.to_s
    @charge_analysis_report.unit ||= "1"

    respond_to do |format|
      format.html do
        render layout: "iframe"
      end
      format.json do
        reports = @charge_analysis_report.search
        sum_record = @charge_analysis_report.sum_record(reports)
        json_data = {}
        json_data[:body] = reports
        json_data[:foot] = [ sum_record ]
        render json: json_data
      end
    end
  end

  private
    def secure?
      false
    end

end
