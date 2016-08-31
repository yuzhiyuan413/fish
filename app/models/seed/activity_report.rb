# -*- encoding : utf-8 -*-
class Seed::ActivityReport < ActiveRecord::Base
  attr_accessor :from_date, :end_date

  def self.search from_date, end_date, tag
    where({:report_time => from_date..end_date, :tag => tag}).order(:report_time)
  end

	def search
		conditions = {:report_time => from_date..end_date}
		conditions[:tag] = System::TagGroup.tag_adaptor(Seed::ActivityReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
    select_columns = [:report_time, :tag, "activity_num as seed_activity_num", :v9_activity_num,
      "(request_num/activity_num) as seed_request_avg", "(v9_request_num/v9_activity_num) as v9_request_avg"]
		Seed::ActivityReport.select(select_columns).where(conditions).order(:tag, :report_time)
	end

  def self.find_activity_situation_by_time tag, record_time
    r = Seed::ActivityReport.new
    r.activity_num = BeeDs::RequestHistory.count_activity(tag, record_time.to_date, record_time)
    r.activation_num = BeeDs::SeedUser.count_activation(tag, record_time.to_date, record_time)
    r.request_num = BeeDs::RequestHistory.count_request(tag, record_time.to_date, record_time)
    r
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end

end
