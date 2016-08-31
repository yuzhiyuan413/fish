# -*- encoding : utf-8 -*-
class Seed::ActivationReport < ActiveRecord::Base
	include RatioHelper
	attr_accessor :from_date, :end_date

	def search
		conditions = {:report_time => (from_date..end_date)}
		if Seed::ActivationReport.exists?(:partner => tag)
			conditions[:partner] = tag
		else
			conditions[:tag] = System::TagGroup.tag_adaptor(Seed::ActivationReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
		end
		Seed::ActivationReport.where(conditions).where("seed_activation_num != 0").order(:tag, :report_time)
	end

	def sum_record records
		return nil if records.blank?
		sum_record = Seed::ActivationReport.new
		sum_record.seed_activation_num = eval records.map(&:seed_activation_num).compact.join('+')
		sum_record.panda_activation_num = eval records.map(&:panda_activation_num).compact.join('+')
		sum_record.old_user_active_num = eval records.map(&:old_user_active_num).compact.join('+')
		sum_record.old_user_activity_num = eval records.map(&:old_user_activity_num).compact.join('+')
		sum_record.bash_activation_num = eval records.map(&:bash_activation_num).compact.join('+')
		sum_record.signature_num = eval records.map(&:signature_num).compact.join('+')
		sum_record.reset_num = eval records.map(&:reset_num).compact.join('+')
		if sum_record.bash_activation_num and sum_record.seed_activation_num
			sum_record.bash_activation_ratio = ratio(sum_record.bash_activation_num, sum_record.seed_activation_num)
		end
		if sum_record.signature_num and sum_record.seed_activation_num
			sum_record.signature_ratio = ratio(sum_record.signature_num, sum_record.seed_activation_num)
		end
		if sum_record.reset_num and sum_record.seed_activation_num
			sum_record.reset_num_ratio = ratio(sum_record.reset_num, sum_record.seed_activation_num)
		end
		sum_record
	end

	def self.partners
		select("distinct partner").where("partner != ''").order(:partner => :desc).map(&:partner).compact
	end

	def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end

end
