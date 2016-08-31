# -*- encoding : utf-8 -*-
class Charge::AliveReport < ActiveRecord::Base
  extend RatioHelper
  attr_accessor :from_date, :end_date

  def search
    conditions = {:product_version => product_version,
                  :report_date => from_date..end_date}
    conditions[:tag] = tag unless tag == "全部组选"
    hide_where_clause = "activation_num != 0"
    Charge::AliveReport.where(conditions).where(hide_where_clause).order(
      :tag, :report_date)
  end

  def self.convert_to_view records
    records.map do |r|
      { report_date: r.report_date, activation_num: r.activation_num,
        stay_alive2: r.stay_alive2_num, stay_alive3: r.stay_alive3_num,
        stay_alive7: r.stay_alive7_num, stay_alive15: r.stay_alive15_num,
        stay_alive30: r.stay_alive30_num,
        ratio_alive2: ratio(r.stay_alive2_num, r.activation_num),
        ratio_alive3: ratio(r.stay_alive3_num, r.activation_num),
        ratio_alive7: ratio(r.stay_alive7_num, r.activation_num),
        ratio_alive15: ratio(r.stay_alive15_num, r.activation_num),
        ratio_alive30: ratio(r.stay_alive30_num, r.activation_num),
        tag: r.tag, product_version: r.product_version
      }
    end
  end

  def self.stay_alive_avg records
    return nil if records.blank?
    idx = [2, 3, 7, 15, 30]
    {}.tap do |x|
      idx.each do |i|
        r = records.select{|r|r.report_date <= i.days.ago.to_date}
        stay_alive_sum = r.map(&"stay_alive#{i}_num".to_sym).compact.sum
        activation_sum = r.map(&:activation_num).compact.sum
        stay_aliva_ratio = stay_alive_sum.blank? ? nil : (activation_sum.to_f == 0.0 ? 0.0 :(stay_alive_sum.to_f/activation_sum.to_f))
        x["stay_aliva_ratio#{i}"] = stay_aliva_ratio
      end
    end
  end

  def self.tags
    select("distinct tag").order(:tag => :desc).map(&:tag).compact
  end

  def self.product_versions
    select("distinct product_version").where("report_date > '2015-02-01'").order(:product_version => :desc).map(&:product_version).compact
  end
end
