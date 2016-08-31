# -*- encoding : utf-8 -*-
class Ework::ConversionReportsController < ApplicationController
  # GET /ework/conversion_reports
  # GET /ework/conversion_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @ework_conversion_report = Ework::ConversionReport.new(params[:ework_conversion_report])
    @ework_conversion_report.from_date ||= 7.days.ago.strftime("%F")
    @ework_conversion_report.end_date ||= Date.today.to_s
    @ework_conversion_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    tag_datas = tags_options_cache(@ework_conversion_report.class)
    @ework_arrival_report_form_json = {name: 'ework_conversion_report_form',action: '/ework/conversion_reports/index',
                                       form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @ework_conversion_report.from_date }},
                                                   {name: 'end_date',attributes: {input_type: 'datetime',default: @ework_conversion_report.end_date }},
                                                   {name: 'tag',attributes: {input_type: 'select',default: @ework_conversion_report.tag,data: tag_datas }}]
                                      }
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        json_data = {form: @ework_arrival_report_form_json}
        if params[:ework_conversion_report]
          @ework_conversion_reports = @ework_conversion_report.search
          @conversion_avg = @ework_conversion_report.conversion_avg(@ework_conversion_reports)
          @conversion_median = Ework::ConversionMedian.find_by_name("Ework::ConversionMedian")
          json_data[:body] = @ework_conversion_reports
          json_data[:foot] = [@conversion_avg,@conversion_median]
        end

        render json: json_data
      end
    end
  end

end
