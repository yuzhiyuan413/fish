class Charge::SmsCatsController < ApplicationController
  before_action :sso_filter, :store_account_id_login
  layout "iframe"

  def index
    @sms_cat = Charge::SmsCat.new(params[:sms_cat])
    @sms_cat_data, @sms_cat_data_total = @sms_cat.search
  end

  def secure?
    false
  end

end
