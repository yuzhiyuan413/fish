class System::Heartbeat
  def self.report
    alarms = []
    check_reports.each do |report, attrs|
      records = report.where(attrs[:conditions])
      if records.present? && records.size == attrs[:record_count]
        attrs[:fields].each do |field|
          records.each do |r|
            alarms << "Report: #{report.to_s}, Field: #{field}." unless r.send(field).to_i > 0
          end
        end
      else
        alarms << "Report '#{report.to_s}' missing records."
      end
    end
    alarms.blank? ? "ok" : alarms.join('<br/>')
  end

  private
  def self.check_reports
    last3today = (2.days.ago.to_date..Date.today)
    last3yesterday = (3.days.ago.to_date..Date.yesterday)
    {
      Seed::ActivityReport => {
        record_count: 3,
        fields: %W{activity_num v9_activity_num},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, report_time: last3today}
      },
      Seed::ActivationReport => {
        record_count: 3,
        fields: %W{seed_activation_num bash_activation_num panda_activation_num },
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, report_time: last3today}
      },
      Seed::AliveReport => {
        record_count: 3,
        fields: %W{activation_num},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, report_time: last3yesterday}
      },
      Seed::SolutionReport => {
        record_count: 3,
        fields: %W{active_count execting_count exected_count success_count
          installed_count},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, plan_id: 0,
          report_date: last3today}
      },
      Seed::PropReport => {
        record_count: 3,
        fields: %W{count success_count},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, manufacturer: "其他厂商",
          report_date: last3today}
      },
      Seed::PropDetailReport => {
        record_count: 3,
        fields: %W{count success_count},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, board: "其他型号",
          report_date: last3today}
      },
      Seed::DeviceDetailReport => {
        record_count: 3,
        fields: %W{count success_count},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, model: "其他型号",
          report_date: last3today}
      },
      Seed::PropDetailMonthlyReport => {
        record_count: 1,
        fields: %W{count success_count},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, board: "其他型号",
          report_date: Date.yesterday.strftime('%Y/%m')}
      },
      Seed::ArrivalReport => {
        record_count: 3,
        fields: %W{seed_activation seed_active seed_executing seed_executied
          seed_successed seed_installed v9_activity},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, report_date: last3today}
      },
      Charge::ActivationReport => {
        record_count: 3,
        fields: %W{activation_num},
        conditions: {tag: Distributers::ChargeTagDistributer::TOTAL_SUM_TAG,
          product_version: Distributers::LoaderVersionDistributer::TOTAL_SUM_LOADERVERSION,
          report_date: last3today}
      },
      Charge::ActivityReport => {
        record_count: 3,
        fields: %W{activity_num request_times request_per_avg cmcc_num cucc_num},
        conditions: {tag: Distributers::ChargeTagDistributer::TOTAL_SUM_TAG,
          province: Distributers::ProvinceDistributer::TOTAL_SUM_PROVINCE,
          product_version: Distributers::LoaderVersionDistributer::TOTAL_SUM_LOADERVERSION,
          report_date: last3today }
      },
      Charge::ActivityMonthReport => {
        record_count: 1,
        fields: %W{activity_num request_times request_per_avg cmcc_num cucc_num},
        conditions: {tag: Distributers::ChargeTagDistributer::TOTAL_SUM_TAG,
          province: Distributers::ProvinceDistributer::TOTAL_SUM_PROVINCE,
          product_version: Distributers::LoaderVersionDistributer::TOTAL_SUM_LOADERVERSION,
          report_date: Date.yesterday.strftime('%Y/%m')}
      },
      Charge::AliveReport => {
        record_count: 3,
        fields: %W{activation_num},
        conditions: {tag: Distributers::ChargeTagDistributer::TOTAL_SUM_TAG,
          product_version: Distributers::LoaderVersionDistributer::TOTAL_SUM_LOADERVERSION,
          report_date: last3yesterday}
      },
      Ework::ArrivalReport => {
        record_count: 3,
        fields: %W{ework_activation seed_active seed_executing seed_executied
          seed_successed seed_installed v9_activity},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, report_date: last3today}
      },
      Ework::ConversionReport => {
        record_count: 3,
        fields: %W{app_activation get_url download_jar merge_jar launch_jar
          seed_active_aid seed_executed_aid},
        conditions: {tag: System::TagGroup::TOTAL_SUM_TAG, report_date: last3today}
      }
    }
  end
end
