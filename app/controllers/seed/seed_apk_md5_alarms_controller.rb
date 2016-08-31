# -*- encoding : utf-8 -*-
class Seed::SeedApkMd5AlarmsController < ApplicationController
  # GET /seed/apk_md5_alarms
  # GET /seed/apk_md5_alarms.json
  include ApplicationHelper
  def index
    params.permit!
    @seed_seed_apk_md5_alarm = Seed::SeedApkMd5Alarm.new(params[:seed_seed_apk_md5_alarm])
    @seed_seed_apk_md5_alarm.from_date ||= Date.today.ago(30.days).to_date.to_s
    @seed_seed_apk_md5_alarm.end_date ||= Date.today.to_s
    tags = SmartDs::ProductTag.options
    form_json = {
      name: 'seed_seed_apk_md5_alarm_form',action: '/seed/seed_apk_md5_alarms/index',
      form_items:[
        {name: 'from_date',attributes: {input_type: 'datetime',default: @seed_seed_apk_md5_alarm.from_date }},
        {name: 'end_date',attributes: {input_type: 'datetime',default: @seed_seed_apk_md5_alarm.end_date }},
        {name: 'tag',attributes: {input_type: 'select', default: @seed_seed_apk_md5_alarm.tag, data: tags }}]
    }
    respond_to do |format|
      format.html #index.html.erb
      format.json do
        json_data = { form: form_json}
        if params[:seed_seed_apk_md5_alarm]
          records = @seed_seed_apk_md5_alarm.search
          sum_record = @seed_seed_apk_md5_alarm.sum_record(records)
          json_data[:body] = records
          json_data[:foot] = [sum_record]
        end
        render json:json_data
      end
    end
  end

end
