class SmartDs::ChargeCodeDeliverHistory < ActiveRecord::Base
  establish_connection "dwh_smart_cobra_#{Rails.env}".to_sym
  self.primary_key = 'id'
  has_many :charge_code_deliver_details
end
