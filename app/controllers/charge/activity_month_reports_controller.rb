# -*- encoding : utf-8 -*-
class Charge::ActivityMonthReportsController < ApplicationController
  # GET /charge_activity_month_reports
  # GET /charge_activity_month_reports.json
  include ApplicationHelper
  include ChargeHelper
  def index
    params.permit!
    @charge_activity_month_report = Charge::ActivityMonthReport.new(params[:charge_activity_month_report])
    @charge_activity_month_report.report_date ||= Date.today.strftime("%Y/%m")
    @charge_activity_month_report.tag ||= "全部标签"
    @charge_activity_month_report.province ||= "全部省份"
    @charge_activity_month_report.product_version ||= "全部版本"
    tags_datas = tags_options_cache(@charge_activity_month_report.class)
    product_version_datas = charge_product_versions_options(@charge_activity_month_report.class)
    province_datas = charge_provinces_options
    @charge_activity_month_report_form_json = {name: 'charge_activity_month_report_form',action: '/charge/activity_month_reports/index',
                                               form_items:[{name: 'report_date',attributes: {input_type: 'datetime_month',default: @charge_activity_month_report.report_date }},
                                                       {name: 'tag',attributes: {input_type: 'select',default: @charge_activity_month_report.tag ,data: tags_datas}},
                                                       {name: 'province',attributes: {input_type: 'select',default: @charge_activity_month_report.province, data: province_datas }},
                                                       {name: 'product_version',attributes: {input_type: 'select',default: @charge_activity_month_report.product_version, data: product_version_datas  }}]
                                          }

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        json_data = {form: @charge_activity_month_report_form_json}
        json_data[:body] = @charge_activity_month_report.search if params[:charge_activity_month_report]
        render json: json_data
      end
    end
  end

end
