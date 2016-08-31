class SmartDs::Partner < ActiveRecord::Base
  establish_connection "daily_smart_#{Rails.env}".to_sym
  has_many :product_tags
end
