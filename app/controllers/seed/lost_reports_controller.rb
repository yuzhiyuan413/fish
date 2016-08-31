class Seed::LostReportsController < ApplicationController
  before_action :set_seed_lost_report, only: [:show, :edit, :update, :destroy]

  # GET /seed/lost_reports
  # GET /seed/lost_reports.json
  def index
    params.permit!
    @seed_lost_reports = Seed::LostReport.new(params[:seed_lost_report])
    respond_to do |format|
      format.html
      format.json do
        records = @seed_lost_reports.search
        json_data = {}
        json_data[:body] = records
        render json: json_data  
      end
    end
  end

end
