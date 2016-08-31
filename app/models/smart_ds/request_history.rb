class SmartDs::RequestHistory < ActiveRecord::Base
  establish_connection "dwh_smart_V9_#{Rails.env}".to_sym
end
