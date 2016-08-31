# -*- encoding : utf-8 -*-
class Charge::ActivationReport < ActiveRecord::Base
  #attr_accessible :activation_num, :product_version, :report_date, :tag
  attr_accessor :from_date, :end_date

  def search
    conditions = {:product_version => product_version,
                  :report_date => from_date..end_date}
    conditions[:tag] = tag unless tag == "全部组选"
    hide_where_clause = "activation_num != 0"
    Charge::ActivationReport.select([:tag, :report_date, :activation_num]
      ).where(conditions).where(hide_where_clause).order(:tag, :report_date)
  end

  def sum_record records
    return nil if records.blank?
    sum_record = Charge::ActivationReport.new
    sum_record.activation_num = records.map(&:activation_num).compact.sum
    sum_record
  end

  def self.tags
    select("distinct tag").order(:tag => :desc).map(&:tag).compact
  end

  def self.product_versions
    select("distinct product_version").where("report_date > '2015-02-01'").order(:product_version => :desc).map(&:product_version).compact
  end
end
