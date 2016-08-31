class CrabDs::CodeDeliverHistory < ActiveRecord::Base
  establish_connection "daily_crab_#{Rails.env}".to_sym
end
