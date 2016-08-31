# -*- encoding : utf-8 -*-
class DateAnalyzer

	attr_accessor :date

	def initialize date
		@date = date
	end

	def get
		if date.nil?
			return [Time.now.at_beginning_of_day.to_date]
		elsif date.start_with?("last")
			num = date.match(/\d+/)[0]
			d = Time.now.to_date
			return (d.ago(num.to_i.days).to_date..d.ago(1.days).to_date).to_a
		elsif date.include?("..")
			begin_date = date.split("..").first
			end_date = date.split("..").last
			return (Time.parse(begin_date).to_date..Time.parse(end_date).to_date).to_a
		else
			[Time.parse(date).to_date]
		end
	end

end
