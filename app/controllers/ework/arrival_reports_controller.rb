# -*- encoding : utf-8 -*-
class Ework::ArrivalReportsController < ApplicationController
  # GET /ework/arrival_reports
  # GET /ework/arrival_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @ework_arrival_report = Ework::ArrivalReport.new(params[:ework_arrival_report])
    @ework_arrival_report.from_date ||= 7.days.ago.strftime("%F")
    @ework_arrival_report.end_date ||= Date.today.to_s
    @ework_arrival_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    tag_datas = tags_options_cache(@ework_arrival_report.class)
    @ework_arrival_report_form_json = {name: 'ework_arrival_report_form',action: '/ework/arrival_reports/index',
                                       form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @ework_arrival_report.from_date }},
                                                   {name: 'end_date',attributes: {input_type: 'datetime',default: @ework_arrival_report.end_date }},
                                                   {name: 'tag',attributes: {input_type: 'select',default: @ework_arrival_report.tag, data: tag_datas }}]
                                      }

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        json_data = {form: @ework_arrival_report_form_json }
        if params[:ework_arrival_report]
          @ework_arrival_reports = @ework_arrival_report.search
          @ework_arrival_report_summray = @ework_arrival_report.sum_record @ework_arrival_reports
          json_data[:body] = @ework_arrival_reports
          json_data[:foot] = [@ework_arrival_report_summray]
        end

        render json: json_data
      end
    end
  end

end
