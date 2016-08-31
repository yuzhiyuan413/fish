class Command::GenerateEworkConversionMedians < Command::CommandCenter
	def run
		sec = Benchmark.realtime do
			column_names = ["download_jar",
											"get_url",
											"launch_jar",
											"merge_jar",
											"seed_active",
											"seed_executed",
											"seed_active_aid",
											"seed_executed_aid"]
			median = Ework::ConversionMedian.find_or_initialize_by({name: "Ework::ConversionMedian"})
			column_names.each do |column_name|
				median.send("#{column_name}_ratio=", ework_conversion_median(column_name))
			end
			median.save
		end
		LOG.info "生成易打工转化率中位数完成，耗时#{sec.to_i}s"
	end

 	private
		def ework_conversion_median column_name
				conversion_avgs = Ework::ConversionReport.conversion_avg(column_name)
				conversion_avgs = conversion_avgs.map(&:avg_val).compact
				conversion_avgs.delete(0)
				conversion_avgs.blank? ? nil : conversion_avgs.median
		end
end