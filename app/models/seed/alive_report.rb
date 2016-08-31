# -*- encoding : utf-8 -*-
class Seed::AliveReport < ActiveRecord::Base
	extend RatioHelper
	attr_accessor :from_date, :end_date
	def search
		conditions = {:report_time => from_date..end_date}
		conditions[:tag] = System::TagGroup.tag_adaptor(Seed::AliveReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
		Seed::AliveReport.where(conditions).where("activation_num != 0").order([:tag,:report_time])
	end

	def self.convert_to_view records
    records.map do |r|
      { report_time: r.report_time, activation_num: r.activation_num,
        stay_alive2: r.stay_alive2, stay_alive3: r.stay_alive3,
        stay_alive7: r.stay_alive7, stay_alive15: r.stay_alive15,
        stay_alive30: r.stay_alive30,
        ratio_alive2: ratio(r.stay_alive2, r.activation_num),
        ratio_alive3: ratio(r.stay_alive3, r.activation_num),
        ratio_alive7: ratio(r.stay_alive7, r.activation_num),
        ratio_alive15: ratio(r.stay_alive15, r.activation_num),
        ratio_alive30: ratio(r.stay_alive30, r.activation_num),
        tag: r.tag
      }
    end
  end

	def stay_alive_avg records
		return nil if records.blank?
		idx = [2, 3, 7, 15, 30]
		{}.tap do |x|
			idx.each do |i|
				r = records.select{|r|r.report_time <= Date.today.ago(i.days).to_date}
				stay_alive_sum = r.map(&"stay_alive#{i}".to_sym).compact.sum
				activation_sum = r.map(&:activation_num).compact.sum
				stay_aliva_ratio = stay_alive_sum.blank? ? nil : (activation_sum.to_f == 0.0 ? 0.0 :(stay_alive_sum.to_f/activation_sum.to_f))
				x["stay_aliva_ratio#{i}"] = stay_aliva_ratio
			end
		end
	end

	def avg_stay_alive=(avg_stay_alive)
	  write_attribute(:avg_stay_alive, avg_stay_alive.capitalize)
	end

	def avg_stay_alive
	  read_attribute(:avg_stay_alive).to_f
	end

	def self.avg_stay_alive key, value
		select("tag, sum(stay_alive#{key}) / sum(activation_num) as avg_stay_alive").where("report_time < ?",value).group(:tag).order("avg_stay_alive")
	end

	def self.tags conditions = nil
		select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
	end
end
