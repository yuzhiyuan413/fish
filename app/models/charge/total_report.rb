# -*- encoding : utf-8 -*-
class Charge::TotalReport < ActiveRecord::Base
  attr_accessible :activity30, :activity7, :product_version, :tag, :total_activation_num, :yesterday_activation_num, :yesterday_activity_num
end
