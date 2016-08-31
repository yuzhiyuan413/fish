# -*- encoding : utf-8 -*-
class Charge::ActivityTrendReportsController < ApplicationController
  # GET /charge_activity_trend_reports
  # GET /charge_activity_trend_reports.json
  include ApplicationHelper
  include ChargeHelper
  def index
    params.permit!
    @activity_trend_report = Charge::ActivityReport.new(params[:charge_activity_trend_report_form])
    @activity_trend_report.from_date ||= 15.days.ago.strftime("%F")
    @activity_trend_report.end_date ||= Date.today.to_s
    @activity_trend_report.tag ||= "全部标签"
    @activity_trend_report.product_version ||= "全部版本"
    @activity_trend_report.operator = "-移动-" if @activity_trend_report.operator.blank?
    @trend_day_header = @activity_trend_report.day_header
    @activity_trend_reports = @activity_trend_report.trend_report_search
    tags_datas = tags_options_cache(@activity_trend_report.class)
    product_version_datas = charge_product_versions_options(@activity_trend_report.class)
    operator_datas = charge_operator_options
    @activity_trend_report_form_json = {name: 'charge_activity_trend_report_form',action: '/charge/activity_trend_reports/index',
                                        form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @activity_trend_report.from_date }},
                                                     {name: 'end_date',attributes: {input_type: 'datetime',default: @activity_trend_report.end_date }},
                                                    {name: 'tag',attributes: {input_type: 'select',default: @activity_trend_report.tag, data: tags_datas }},
                                                     {name: 'product_version',attributes: {input_type: 'select',default: @activity_trend_report.product_version, data: product_version_datas }},
                                                     {name: 'operator',attributes: {input_type: 'select',default: @activity_trend_report.operator, data: operator_datas }}
                                                     ]}
                                        
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {form: @activity_trend_report_form_json } }
    end
  end

end
