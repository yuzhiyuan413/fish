class Charge::MonthlyCodeAliveReportsController < ApplicationController
  before_action :sso_filter, :store_account_id_login
  layout "iframe"
  def index
    params.permit!
    @alive_report = Charge::MonthlyCodeAliveReport.new(params[:charge_monthly_code_alive_report])
    @alive_report.from_date ||= 6.month.ago.strftime("%Y-%m")
    @alive_report.end_date ||= Date.today.strftime("%Y-%m")
    @alive_report.code ||= ""
    @alive_report.dest_number ||= ""
    @alive_report.sp_id ||= ""
    form_data = {
      name: 'charge_monthly_code_alive_report_form',
      action: '/charge/monthly_code_alive_reports/index'
    }
    respond_to do |format|
      format.html
      format.json do
        json_data = {form: form_data}
        if params[:charge_monthly_code_alive_report]
          json_data[:body] = @alive_report.search
        end
        render json: json_data
      end
    end
  end

  def edit
    @report = Charge::MonthlyCodeAliveReport.find(params[:id])
  end

  def update
    @report = Charge::MonthlyCodeAliveReport.find(params[:id])

    if @report.update_and_calculate(report_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  private
  def secure?
    false
  end

  def report_params
    params.require(:charge_monthly_code_alive_report).permit(:id, :order_alive, :order_charged_alive, :order_activation, :order_activation_charged)
  end
end
