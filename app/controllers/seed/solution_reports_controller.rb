# -*- encoding : utf-8 -*-
class Seed::SolutionReportsController < ApplicationController
  # GET /seed/solution_reports
  # GET /seed/solution_reports.json
  include ApplicationHelper
  def index
    params.permit!
    @seed_solution_report = Seed::SolutionReport.new(params[:seed_solution_report])
    @seed_solution_report.from_date ||= Date.today.ago(7.days).to_date.to_s
    @seed_solution_report.end_date ||= Date.today.to_s
    @seed_solution_report.tag ||= System::TagGroup::TOTAL_SUM_TAG
    tags = tags_options_cache(@seed_solution_report.class)
    @seed_solution_report_form_json = {name: 'seed_solution_report_form',action: '/seed/solution_reports/index',
                                         form_items:[{name: 'from_date',attributes: {input_type: 'datetime',default: @seed_solution_report.from_date }},
                                                     {name: 'end_date',attributes: {input_type: 'datetime',default: @seed_solution_report.end_date }},
                                                     {name: 'tag',attributes: {input_type: 'select',default: @seed_solution_report.tag,data: tags }}]
                                        }
    respond_to do |format|
      format.html # index.html.erb
      format.json do 
        json_data = { form: @seed_solution_report_form_json}
        json_data[:body] = @seed_solution_report.search if params[:seed_solution_report]
        render :json => json_data
      end
    end
  end

end
