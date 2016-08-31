class Charge::MonthlyCodeDownlinkReportGenerator
  attr_accessor :code_info, :option

  CODES = [
    {service_id: 1, times: 8, code: 'XW', dest_number: 10662453,  sp_id: 1043, code_name: 'XW_10662453_8元'},
    {service_id: 2, times: 5, code: 'GS', dest_number: 106624532, sp_id: 1043, code_name: 'GS_106624532_5元'},
    {service_id: 3, times: 3, code: 'CX', dest_number: 106624537, sp_id: 1043, code_name: 'CX_106624537_3元'},
    {service_id: 8, times: 1, code: 'SW', dest_number: 106624533, sp_id: 1043, code_name: 'SW_106624533_10元'}
  ]

  REPORT_TYPES = [
    Charge::MonthlyCodeDownlinkReport::DAILY,
    Charge::MonthlyCodeDownlinkReport::MONTHLY
  ]

  def initialize(code_info, option)
    @code_info = code_info
    @option    = option
  end

  def self.generate_reports(report_date)
    date = report_date.to_date
    end_date  = date + 1.day
    REPORT_TYPES.each do |report_type|
      from_date = report_type == Charge::MonthlyCodeDownlinkReport::DAILY ? date : date.at_beginning_of_month

      CODES.each do |code_info|
        option = {from_date: from_date, end_date: end_date, report_type: report_type}
        self.new(code_info, option).save_report
      end
    end
    generate_total_reports(report_date)
  end

  def self.generate_total_reports(report_date)
    date = report_date.to_date.at_beginning_of_month
    CODES.each do |code_info|
      conditions = {report_type: Charge::MonthlyCodeDownlinkReport::MONTHLY, code_name: code_info[:code_name]}
      m_report = Charge::MonthlyCodeDownlinkReport.where(conditions).where('report_date <= ?', date.at_end_of_month).order(:report_date).last
      next if m_report.blank?

      init_data = {
        report_date: date,
        report_type: Charge::MonthlyCodeDownlinkReport::TOTAL,
        code_name: code_info[:code_name]
      }
      report = Charge::MonthlyCodeDownlinkReport.find_or_initialize_by(init_data)
      m_report.attributes.each do |k, v|
        report.send(k + "=", v) if k.ends_with?('_users_num')
      end
      report.save
    end
  end

  def save_report
    init_data = {
      report_date: option[:from_date],
      report_type: option[:report_type],
      code_name: code_info[:code_name]
    }
    report = Charge::MonthlyCodeDownlinkReport.find_or_initialize_by(init_data)
    report.attributes.each do |attr_name, _|
      if attr_name.ends_with?('_users_num')
        value = self.send(attr_name)
        report.send(attr_name + "=", value)
      end
    end

    report.save
  end

  def deliver_users_num
    histories = SmartDs::ChargeCodeDeliverHistory.select("distinct uuid")
    histories = histories.joins(:charge_code_deliver_details)
    histories = histories.where("code = ? and dest_number = ? and service_provider_id = ?", code_info[:code], code_info[:dest_number], code_info[:sp_id])
    histories = histories.where("deliver_time >= ? and deliver_time < ?", option[:from_date], option[:end_date])
    histories.count
  end

  def theory_successful_users_num
    histories = SmartDs::BaseCodeChargeHistory.select("distinct uuid")
    histories = histories.where(code: "*#T#{code_info[:code]}", dest_number: code_info[:dest_number], sp_id: code_info[:sp_id])
    histories = histories.where("pay_time >= ? and pay_time < ?", option[:from_date], option[:end_date])
    histories.count
  end

  def activation_users_num
    histories = CrabDs::MonthlyCodeChargeHistory.select("distinct uuid")
    histories = histories.where(code: code_info[:code], dest_number: code_info[:dest_number], sp_id: code_info[:sp_id], action_id: Charge::MonthlyCodeAliveReport::SUBSCRIBE)
    histories = histories.where(time: option[:from_date]...option[:end_date])
    histories.count
  end

  def lt_72_unsubscribed_users_num
    unsubscribed_users_num('<')
  end

  def gt_72_unsubscribed_users_num
    unsubscribed_users_num('>=')
  end

  def successful_users_num
    users_num = downlink_users_num("having num >= #{code_info[:times]}")
    return users_num if option[:report_type] == Charge::MonthlyCodeDownlinkReport::MONTHLY
    return users_num if option[:from_date].day == 1
    users_num_yesterday = downlink_users_num("having num >= #{code_info[:times]}", option[:end_date] - 1.day)
    users_num - users_num_yesterday
  end

  # 下发不达标的用户数
  def low_downlink_users_num
    downlink_users_num("having num < #{code_info[:times]} and num > 0")
  end

  # 下发为0的用户数
  def no_downlink_users_num
    downlink_users_num("having num = 0")
  end

  def downlink_users_num(having, month_end_date=nil)
    sql = downlink_users_num_sql(having)
    conditions = {
      service_id: code_info[:service_id],
      month_start_date: option[:from_date].at_beginning_of_month,
      month_end_date: month_end_date || option[:end_date],
      start_date: option[:from_date],
      end_date: option[:end_date]
    }
    res = SmartDs::ZhongTianMonthlyData.find_by_sql([sql, conditions]).first
    res.users_num
  end

  def downlink_users_num_sql(having)
    daily_sql = <<-SQL
      select succ_records.mobile, sum(succ_records.status) num from zhong_tian_monthly_data succ_records
      inner join
        (select distinct mobile from zhong_tian_monthly_data where service_id = :service_id and pay_date >= :start_date and pay_date < :end_date) records
      on succ_records.mobile = records.mobile
      where service_id = :service_id and pay_date >= :month_start_date and pay_date < :month_end_date
      group by succ_records.mobile
    SQL

    monthly_sql = <<-SQL
      select mobile, sum(status) num from zhong_tian_monthly_data
      where service_id = :service_id and pay_date >= :month_start_date and pay_date < :end_date
      group by mobile
    SQL

    sql = option[:report_type] == Charge::MonthlyCodeDownlinkReport::DAILY ? daily_sql : monthly_sql
    sql << " " + having
    "select count(*) users_num from (#{sql}) h3"
  end

  # 72小时内外退订的新增用户数的sql
  def unsubscribed_users_num(logic_operator)
    sql = <<-SQL
      select count(distinct dg.uuid) user_num from (
        select uuid, max(time) dg_time from monthly_code_charge_histories
        where action_id = 1 and time between :start_time_1 and :end_time
        and code = :code and dest_number = :dest_number and sp_id = :sp_id
        group by uuid
      ) dg
      inner join (
        select uuid, max(time) td_time from monthly_code_charge_histories
        where action_id = 2 and time between :start_time and :end_time
        and code = :code and dest_number = :dest_number and sp_id = :sp_id
        group by uuid
      ) td
       on dg.uuid = td.uuid
       where td_time > dg_time
       and TIMESTAMPDIFF(second, dg_time, td_time)
    SQL
    sql << "#{logic_operator} 259200"
    conditions = {
      start_time_1: option[:from_date].at_beginning_of_month,
      start_time: option[:from_date],
      end_time: option[:end_date],
      code: code_info[:code],
      dest_number: code_info[:dest_number],
      sp_id: code_info[:sp_id]
    }
    result = CrabDs::MonthlyCodeChargeHistory.find_by_sql([sql, conditions]).first
    result.user_num
  end

end
