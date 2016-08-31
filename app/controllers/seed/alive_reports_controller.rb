# -*- encoding : utf-8 -*-
class Seed::AliveReportsController < ApplicationController 
  # GET /seed/alive_reports
  # GET /seed/alive_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @seed_alive_report = Seed::AliveReport.new(params[:seed_alive_report])
    @seed_alive_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    @seed_alive_report.from_date ||= Date.today.ago(7.days).to_date.to_s
    @seed_alive_report.end_date ||= Date.yesterday.to_s
    tags = tags_options_cache(@seed_alive_report.class)
    @seed_alive_report_form_json = {name: 'seed_alive_report_form',action: '/seed/alive_reports/index',
                                      form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @seed_alive_report.from_date }},
                                                  {name: 'end_date',attributes: {input_type: 'datetime',default: @seed_alive_report.end_date }},
                                                  {name: 'tag',attributes: {input_type: 'select',default: @seed_alive_report.tag,data: tags }}]}
    respond_to do |format|
      format.html # index.html.erb
      format.json do 
        json_data = {form: @seed_alive_report_form_json }
        if params[:seed_alive_report]
          @seed_alive_reports = @seed_alive_report.search
          view_records = Seed::AliveReport.convert_to_view( @seed_alive_reports)
          @alive_report_avg = @seed_alive_report.stay_alive_avg @seed_alive_reports
          json_data[:body] = view_records
          json_data[:foot] = [Median.find_by_name(Seed::AliveReport.to_s),@alive_report_avg]
        end
        
        render :json => json_data
      end
    end
  end

end
