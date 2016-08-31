# -*- encoding : utf-8 -*-
class Seed::ApkMd5AlarmReportsController < ApplicationController
  # GET /apk_md5_alarm_reports
  # GET /apk_md5_alarm_reports.json
  def index
    @apk_md5_alarm_reports = ApkMd5AlarmReport.all
    @md5_alarm_sum_record = ApkMd5AlarmReport.sum_records @apk_md5_alarm_reports
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @apk_md5_alarm_reports }
    end
  end

end
