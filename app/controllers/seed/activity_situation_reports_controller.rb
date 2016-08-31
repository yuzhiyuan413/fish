# -*- encoding : utf-8 -*-
class Seed::ActivitySituationReportsController < ApplicationController
  # GET /seed/activity_situation_reports
  # GET /seed/activity_situation_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @activity_situation_report = Seed::ActivitySituationReport.new(params[:seed_activity_situation_report])
    @activity_situation_report.report_type = "1"
    @activity_situation_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    tags = tags_options_cache(@activity_situation_report.class)
    @activity_situation_report_json = {name: 'activity_situation_report_form',action: '/seed/activity_situation_reports/index',
                                       form_items:[{name: 'tag',attributes: {input_type: 'select',default: @activity_situation_report.tag, data: tags}}]
    }
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        json_data = {form: @activity_situation_report_json}
        if params[:seed_activity_situation_report]
          @situation_reports = @activity_situation_report.situation_reports.compact
          @total_report = @activity_situation_report.total_report
          #json_data[:body] = params[:name] == "activity_situation" ? @situation_reports : @total_report
          json_data[:body] = @situation_reports
          json_data[:other_body] = @total_report
        end
        render json: json_data
      end
    end
  end

end
