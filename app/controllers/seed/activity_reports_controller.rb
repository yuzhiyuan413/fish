# -*- encoding : utf-8 -*-
class Seed::ActivityReportsController < ApplicationController
  # GET /seed/activity_reports
  # GET /seed/activity_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @seed_activity_report = Seed::ActivityReport.new(params[:seed_activity_report])
    @seed_activity_report.from_date ||= Date.today.ago(7.days).to_date.to_s
    @seed_activity_report.end_date ||= Date.today.to_s
    @seed_activity_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    tags = tags_options_cache(@seed_activity_report.class)
    @seed_activity_report_form_json = {name: 'seed_activity_report_form',action: '/seed/activity_reports/index',
                                      form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @seed_activity_report.from_date }},
                                                  {name: 'end_date',attributes: {input_type: 'datetime',default: @seed_activity_report.end_date }},
                                                  {name: 'tag',attributes: {input_type: 'select',default: @seed_activity_report.tag,data: tags }}]}
    respond_to do |format|
      format.html # index.html.erb 
      format.json do
        json_data = {form: @seed_activity_report_form_json }
        json_data[:body] = @seed_activity_report.search if params[:seed_activity_report]
        render :json => json_data
      end
    end
  end
end
