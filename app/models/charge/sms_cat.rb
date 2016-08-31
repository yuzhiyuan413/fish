class Charge::SmsCat

	attr_accessor :start_time, :end_time

  def initialize sms_cat
    sms_cat ||= {}
    @start_time = sms_cat[:start_time] || Time.now.at_beginning_of_day.to_s(:db)
    @end_time   = sms_cat[:end_time] || Time.now.to_s(:db)
  end

  def search
    sms_cat_data = search_sms_cat
    sms_register_data = search_sms_register

    sms_data_total = {}
    sms_cat_hash = {}
    sms_register_data.each do |data|
      sms_cat_hash[data.smscat_number] ||= {}
      sms_cat_hash[data.smscat_number][data.hour] ||= {}
      sms_cat_hash[data.smscat_number][data.hour][:register_num] = data.total
      sms_data_total[data.smscat_number] ||= {}
      register_data = sms_data_total[data.smscat_number][:sms_register_total].to_i
      sms_data_total[data.smscat_number][:sms_register_total] = register_data + data.total
    end
    sms_cat_data.each do |data|
      sms_cat_hash[data.smscat_number] ||= {}
      sms_cat_hash[data.smscat_number][data.hour] ||= {}
      sms_cat_hash[data.smscat_number][data.hour][:receive_num] = data.total
      sms_data_total[data.smscat_number] ||= {}
      cat_data = sms_data_total[data.smscat_number][:sms_cat_total].to_i
      sms_data_total[data.smscat_number][:sms_cat_total] = cat_data + data.total
    end
    return sms_cat_hash, sms_data_total
  end

  private
  def search_sms_cat
    sql =<<-SQL
       SELECT count(*) as total, smscat_number, Hour(record_time) as hour
       FROM sms_cat_histories
       WHERE record_time BETWEEN ? and ?
       GROUP BY Hour(record_time), smscat_number
    SQL
    CrabDs::SmsCatHistory.find_by_sql([sql, start_time, end_time])
  end

  def search_sms_register
  	sql =<<-SQL
       SELECT count(*) as total, smscat_number, Hour(record_time) as hour
       FROM sms_register_histories
       WHERE record_time BETWEEN ? and ?
       GROUP BY Hour(record_time), smscat_number
    SQL
    CrabDs::SmsCatHistory.find_by_sql([sql, start_time, end_time])
  end

end