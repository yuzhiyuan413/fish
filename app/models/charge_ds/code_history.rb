class ChargeDs::CodeHistory < ActiveRecord::Base
  establish_connection "dwh_crab_#{Rails.env}".to_sym
end
