class CrabDs::MonthlyCodeChargeHistory < ActiveRecord::Base
  establish_connection "daily_crab_#{Rails.env}".to_sym
end