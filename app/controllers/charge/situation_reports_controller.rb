# -*- encoding : utf-8 -*-
class Charge::SituationReportsController < ApplicationController
  # GET /charge/situation_reports
  # GET /charge/situation_reports.json
  include ApplicationHelper
  include ChargeHelper
  def index
    params.permit!
    @charge_situation_report = Charge::SituationReport.new(params[:charge_situation_report])
    @charge_situation_report.tag ||= "全部标签"
    @charge_situation_report.product_version ||= "全部版本"
    product_version_datas = charge_product_versions_options(@charge_situation_report.class)
    tags_datas = tags_options_cache(@charge_situation_report.class)
    @charge_situation_report_json = {name: 'charge_situation_report_form',action: '/charge/situation_reports/index',
                                     form_items:[{name: 'tag',attributes: {input_type: 'select',default: @charge_situation_report.tag ,data: tags_datas}},
                                                   {name: 'product_version',attributes: {input_type: 'select',default: @charge_situation_report.product_version, data: product_version_datas}}]
                                    }
    respond_to do |format| 
      format.html # index.html.erb
      format.json do
        json_data = {form: @charge_situation_report_json}
        if params[:charge_situation_report]
          @situation_reports = @charge_situation_report.situation_reports.compact
          @total_report = @charge_situation_report.total_report
          #json_data[:body] = params[:name] == "charge_situation" ? @situation_reports : @total_report
          json_data[:body] = @situation_reports
          json_data[:other_body] = @total_report
        end
        render json: json_data
      end
    end
  end

end
