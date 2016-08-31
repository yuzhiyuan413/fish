# -*- encoding : utf-8 -*-
class Seed::PropDetailMonthlyReportsController < ApplicationController
  # GET /seed/prop_detail_monthly_reports
  # GET /seed/prop_detail_monthly_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @seed_prop_detail_monthly_report = Seed::PropDetailMonthlyReport.new(params[:seed_prop_detail_monthly_report])
    @seed_prop_detail_monthly_report.report_date ||= Date.yesterday.strftime("%Y/%m")
    @seed_prop_detail_monthly_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    @seed_prop_detail_monthly_report.manufacturer ||= "全部厂商"
    @seed_prop_detail_monthly_report.board ||= "全部型号"
    tags = tags_options_cache(@seed_prop_detail_monthly_report.class)
    manufacturers = manufacturers_options
    boards = boards_options
    @seed_prop_detail_monthly_report_form_json = {name: 'seed_prop_detail_monthly_report_form',action: '/seed/prop_detail_monthly_reports/index',
                                        form_items:[{name: 'report_date',attributes: {input_type: 'datetime_month',default: @seed_prop_detail_monthly_report.report_date }},
                                                    {name: 'tag',attributes: {input_type: 'select',default: @seed_prop_detail_monthly_report.tag,data: tags }},
                                                     {name: 'manufacturer',attributes: {input_type: 'select',default: @seed_prop_detail_monthly_report.manufacturer,data:manufacturers }},
                                                     {name: 'board',attributes: {input_type: 'select',default: @seed_prop_detail_monthly_report.board,data: boards }}]
                                        }

    respond_to do |format|
      format.html # index.html.erb
      format.json do 
        json_data = { form: @seed_prop_detail_monthly_report_form_json }
        json_data[:body] = @seed_prop_detail_monthly_report.search if params[:seed_prop_detail_monthly_report]
        render :json => json_data
      end
    end
  end

end
