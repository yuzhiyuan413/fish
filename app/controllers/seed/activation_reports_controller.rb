# -*- encoding : utf-8 -*-
class Seed::ActivationReportsController < ApplicationController
  # GET /seed/seed_activation_reports
  # GET /seed/seed_activation_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @seed_activation_report = Seed::ActivationReport.new(params[:seed_activation_report])
    @seed_activation_report.from_date ||= Date.today.ago(7.days).to_date.to_s
    @seed_activation_report.end_date ||= Date.today.to_s
    @seed_activation_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    tags = tags_options_cache(@seed_activation_report.class)
    @seed_activation_report_form_json = {name: 'seed_activation_report_form',action: '/seed/activation_reports/index',
                                         form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @seed_activation_report.from_date }},
                                                     {name: 'end_date',attributes: {input_type: 'datetime',default: @seed_activation_report.end_date }},
                                                     {name: 'tag',attributes: {input_type: 'select', default: @seed_activation_report.tag, data:tags }}]
                                        }
    respond_to do |format|
      format.html #index.html.erb
      format.json do
        json_data = { form: @seed_activation_report_form_json}
        if params[:seed_activation_report]
          @seed_activation_reports = @seed_activation_report.search
          @seed_activation_sum_record = @seed_activation_report.sum_record @seed_activation_reports
          json_data[:body] = @seed_activation_reports
          json_data[:foot] = [@seed_activation_sum_record]
        end
        render json:json_data
      end
    end
  end

end
