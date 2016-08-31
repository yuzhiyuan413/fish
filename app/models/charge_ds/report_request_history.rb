class ChargeDs::ReportRequestHistory < ActiveRecord::Base
  establish_connection "dwh_crab_#{Rails.env}".to_sym
  self.table_name = :charge_request_histories
end
