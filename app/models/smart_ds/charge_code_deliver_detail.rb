class SmartDs::ChargeCodeDeliverDetail < ActiveRecord::Base
  establish_connection "dwh_smart_cobra_#{Rails.env}".to_sym
  belongs_to :charge_code_deliver_history
end
