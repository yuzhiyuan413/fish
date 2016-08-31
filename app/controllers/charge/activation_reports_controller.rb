# -*- encoding : utf-8 -*-
class Charge::ActivationReportsController < ApplicationController
  # GET /charge_activation_reports
  # GET /charge_activation_reports.json
  include ApplicationHelper
  include ChargeHelper
  def index
    params.permit!
    @charge_activation_report = Charge::ActivationReport.new(params[:charge_activation_report])
    @charge_activation_report.from_date ||= 7.days.ago.strftime("%F")
    @charge_activation_report.end_date ||= Date.today.to_s
    @charge_activation_report.tag ||= "全部标签"
    @charge_activation_report.product_version ||= "全部版本"
    product_version_datas = charge_product_versions_options(@charge_activation_report.class)
    tags_datas = tags_options_cache(@charge_activation_report.class)
    @charge_activation_report_form_json = {name: 'charge_activation_report_form',action: '/charge/activation_reports/index',
                                         form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @charge_activation_report.from_date }},
                                                     {name: 'end_date',attributes: {input_type: 'datetime',default: @charge_activation_report.end_date }},
                                                     {name: 'tag',attributes: {input_type: 'select',default: @charge_activation_report.tag, data: tags_datas }},
                                                     {name: 'product_version',attributes: {input_type: 'select',default: @charge_activation_report.product_version, data: product_version_datas}}]
                                        }
    respond_to do |format|
      format.html
      format.json do
        json_data = {form: @charge_activation_report_form_json}
        if params[:charge_activation_report]
          @charge_activation_reports = @charge_activation_report.search
          @charge_activation_sum_record = @charge_activation_report.sum_record @charge_activation_reports
          json_data[:body] = @charge_activation_reports
          json_data[:foot] = [@charge_activation_sum_record]
        end
        render json: json_data
      end
    end
  end
  
end
