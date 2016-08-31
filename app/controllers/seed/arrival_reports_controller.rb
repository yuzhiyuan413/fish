# -*- encoding : utf-8 -*-
class Seed::ArrivalReportsController < ApplicationController
  # GET /seed/arrival_reports
  # GET /seed/arrival_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @seed_arrival_report = Seed::ArrivalReport.new(params[:seed_arrival_report])
    @seed_arrival_report.from_date ||= 7.days.ago.strftime("%F")
    @seed_arrival_report.end_date ||= Date.today.to_s
    @seed_arrival_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    tags = tags_options_cache(@seed_arrival_report.class)
    form_json = {
      name: 'seed_arrival_report_form',action: '/seed/arrival_reports/index',
      form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @seed_arrival_report.from_date }},
                  {name: 'end_date',attributes: {input_type: 'datetime',default: @seed_arrival_report.end_date }},
                  {name: 'tag',attributes: {input_type: 'select',default: @seed_arrival_report.tag,data: tags }}]
    }
    respond_to do |format|
      format.html # index.html.erb 
      format.json do
        json_data = {form: form_json }
        if params[:seed_arrival_report]
          records = @seed_arrival_report.search
          sum_record = @seed_arrival_report.sum_record(records)
          json_data[:body] = records
          json_data[:foot] = [sum_record]
          p json_data
        end
        render json: json_data
      end
    end
  end

end
