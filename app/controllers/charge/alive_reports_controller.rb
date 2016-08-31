# -*- encoding : utf-8 -*-
class Charge::AliveReportsController < ApplicationController
  # GET /charge_alive_reports
  # GET /charge_alive_reports.json
  include ApplicationHelper
  include ChargeHelper
  def index
    params.permit!
    @charge_alive_report = Charge::AliveReport.new(params[:charge_alive_report])
    @charge_alive_report.from_date ||= 7.days.ago.strftime("%F")
    @charge_alive_report.end_date ||= Date.today.to_s
    @charge_alive_report.tag ||= "全部标签"

    @charge_alive_report.product_version ||= "全部版本"
    product_version_datas = charge_product_versions_options(@charge_alive_report.class)
    tags_datas = tags_options_cache(@charge_alive_report.class)
    @charge_alive_report_form_json = {name: 'charge_alive_report_form',action: '/charge/alive_reports/index',
                                      form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @charge_alive_report.from_date }},
                                                     {name: 'end_date',attributes: {input_type: 'datetime',default: @charge_alive_report.end_date }},
                                                     {name: 'tag',attributes: {input_type: 'select',default: @charge_alive_report.tag, data: tags_datas }},
                                                     {name: 'product_version',attributes: {input_type: 'select',default: @charge_alive_report.product_version, data: product_version_datas }}]
                                      }
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        data_json = {form: @charge_alive_report_form_json}
        if params[:charge_alive_report]
          records = @charge_alive_report.search
          view_records = Charge::AliveReport.convert_to_view(records)
          avg_record = Charge::AliveReport.stay_alive_avg(records)
          data_json[:body] = view_records
          data_json[:foot] = [avg_record]
        end

        render json: data_json
      end
    end
  end

end
