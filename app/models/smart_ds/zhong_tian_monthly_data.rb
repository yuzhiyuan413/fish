class SmartDs::ZhongTianMonthlyData < ActiveRecord::Base
  establish_connection "daily_smart_#{Rails.env}".to_sym
  SUCCESS = 1
  FAIL = 2
end
