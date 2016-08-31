class Charge::MonthlyCodeAliveReportGenerator < ActiveRecord::Base
  def initialize(year, month)
    @this_month = DateTime.new(year, month).all_month
  end

  def build
    codes.each do |code|
      init_data = {
        report_date: @this_month.first.to_date,
        sp_id: code.sp_id,
        code: code.code,
        dest_number: code.dest_number
      }
      report = Charge::MonthlyCodeAliveReport.find_or_initialize_by(init_data)
      report.activation = activation_num(code)
      report.lt_72 = lt_72_num(code)
      report.gt_72 = gt_72_num(code)
      report.unsubscribed_alive = unsubscribed_alive_num(code)
      report.sp_name = SmartDs::ServiceProvider.where(id: report.sp_id).first.try(:name)
      last_report = report.class.where(report_date: report.report_date - 1.month, sp_id: report.sp_id, code: report.code, dest_number: report.dest_number).first
      if last_report
        report.last_month_deducted_alive = last_report.order_alive + last_report.order_activation - last_report.lt_72 - last_report.gt_72 - last_report.unsubscribed_alive
      end
      report.save
    end
  end

  private
  def codes
    CrabDs::MonthlyCodeChargeHistory.select(:sp_id, :code, :dest_number).where(time: @this_month).distinct
  end

  # 72小时内退订的新增用户数
  def lt_72_num(code)
    data = conditions(code)
    sql = sql_72('<')
    result = CrabDs::MonthlyCodeChargeHistory.find_by_sql([sql, data]).first
    result.user_num
  end

  # 72小时外退订的新增用户数
  def gt_72_num(code)
    data = conditions(code)
    sql = sql_72('>=')
    result = CrabDs::MonthlyCodeChargeHistory.find_by_sql([sql, data]).first
    result.user_num
  end

  # 新增用户数
  def activation_num(code)
    if @activation_num.nil?
      @activation_num = {}
      results = CrabDs::MonthlyCodeChargeHistory.where(time: @this_month, action_id: Charge::MonthlyCodeAliveReport::SUBSCRIBE)
      results = results.group(:sp_id, :code, :dest_number).count('distinct uuid')
      results.each do |group_values, value|
        key = group_values.join('_')
        @activation_num[key] = value
      end
    end
    return @activation_num[uniq_key code] || 0
  end

  # 留存用户退订数
  def unsubscribed_alive_num(code)
    sql = <<-SQL
      select count(distinct h1.uuid) unsubscribed_alive_num from  (
        select uuid from monthly_code_charge_histories
        where action_id = :unsubscribe_action and `time`  between :start_time and :end_time and code = :code
        and dest_number = :dest_number and sp_id = :sp_id) h1
      left join (
        select uuid from monthly_code_charge_histories where
        action_id = :subscribe_action and `time`  between :start_time and :end_time and code = :code
        and dest_number = :dest_number and sp_id = :sp_id) h2
      on h1.uuid = h2.uuid
      where h2.uuid is null
    SQL

    result = CrabDs::MonthlyCodeChargeHistory.find_by_sql([sql, conditions(code)]).first
    result ? result.unsubscribed_alive_num : 0
  end

  def uniq_key(code)
    "#{code.sp_id}_#{code.code}_#{code.dest_number}"
  end

  def conditions(code)
    {
      code: code.code,
      sp_id: code.sp_id,
      dest_number: code.dest_number,
      subscribe_action: Charge::MonthlyCodeAliveReport::SUBSCRIBE,
      unsubscribe_action: Charge::MonthlyCodeAliveReport::UNSUBSCRIBE,
      start_time: @this_month.first,
      end_time: @this_month.last
    }
  end

  # 72小时内外退订的新增用户数的sql
  def sql_72(logic_operator)
    sql = <<-SQL
      select count(distinct dg.uuid) user_num from (
        select uuid, max(time) dg_time from monthly_code_charge_histories
        where action_id = :subscribe_action and time between :start_time and :end_time
        and code = :code and dest_number = :dest_number and sp_id = :sp_id
        group by uuid
      ) dg
      inner join (
        select uuid, max(time) td_time from monthly_code_charge_histories
        where action_id = :unsubscribe_action and time between :start_time and :end_time
        and code = :code and dest_number = :dest_number and sp_id = :sp_id
        group by uuid
      ) td
       on dg.uuid = td.uuid
       where td_time > dg_time
       and TIMESTAMPDIFF(second, dg_time, td_time)
    SQL
    sql << "#{logic_operator} 259200"
  end
end
