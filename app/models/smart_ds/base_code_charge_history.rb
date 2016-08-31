class SmartDs::BaseCodeChargeHistory < ActiveRecord::Base
  establish_connection "dwh_smart_cobra_#{Rails.env}".to_sym
end
