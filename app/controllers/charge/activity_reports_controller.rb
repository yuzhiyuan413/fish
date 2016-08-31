# -*- encoding : utf-8 -*-
class Charge::ActivityReportsController < ApplicationController
  # GET /charge_activity_reports
  # GET /charge_activity_reports.json
  include ApplicationHelper
  include ChargeHelper
  def index
    params.permit!
    @charge_activity_report = Charge::ActivityReport.new(params[:charge_activity_report])
    @charge_activity_report.from_date ||= 1.month.ago.strftime("%F")
    @charge_activity_report.end_date ||= Date.today.to_s

    @charge_activity_report.tag ||= "全部标签"
    @charge_activity_report.province ||= "全部省份"
    @charge_activity_report.product_version ||= "全部版本"
    tags_datas = tags_options_cache(@charge_activity_report.class)
    product_version_datas = charge_product_versions_options(@charge_activity_report.class)
    province_datas = charge_provinces_options
    @charge_activity_report_form_json = {name: 'charge_activity_report_form',action: '/charge/activity_reports/index',
                                         form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @charge_activity_report.from_date }},
                                                           {name: 'end_date',attributes: {input_type: 'datetime',default: @charge_activity_report.end_date }},
                                                           {name: 'tag',attributes: {input_type: 'select',default: @charge_activity_report.tag,data: tags_datas }},
                                                           {name: 'province',attributes: {input_type: 'select',default: @charge_activity_report.province,data: province_datas}},
                                                           {name: 'product_version',attributes: {input_type: 'select',default: @charge_activity_report.product_version, data: product_version_datas }}]
                                        }



    Charge::ActivityReport.select([:province,:product_version])
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        json_data = {form: @charge_activity_report_form_json}
        json_data[:body] = @charge_activity_report.search if params[:charge_activity_report]
        render json: json_data
      end
    end
  end

end
