class Charge::MonthlyCodeAliveReport < ActiveRecord::Base
  SUBSCRIBE = 1
  UNSUBSCRIBE = 2

  attr_accessor :from_date, :end_date

  def code_name
    "#{code}_#{dest_number}"
  end

  def search
    @from_date = parse_to_date(from_date)
    @end_date = parse_to_date(end_date)
    conditions = { report_date: @from_date..@end_date }
    conditions[:code] = self.code if self.code.present?
    conditions[:dest_number] = self.dest_number if self.dest_number.present?
    conditions[:sp_id] = self.sp_id if self.sp_id.present?
    self.class.where(conditions).order(:report_date)
  end

  def update_and_calculate(params)
    self.class.transaction do
      self.update(params)
      self.deducted_alive = self.theory_alive - self.order_alive
      self.deducted_activation = self.activation - self.order_activation
      self.save
    end
  end

  private
  def parse_to_date(date_str)
    reg = /(\d{4})[-\/](\d{2})/
    match_data = date_str.to_s.match(reg)
    return Date.today.beginning_of_month if match_data.nil?
    year, month = match_data[1..2]
    Date.new(year.to_i, month.to_i)
  end
end
