class Command::GenerateSeedAliveMedians < Command::CommandCenter
	def run
		sec = Benchmark.realtime do
			medians = %w{Seed::AliveReport}
			dates = date_range(Date.today, :ago)
			stay_alive_idx = %w{2 3 7 15 30}
			medians.each do |mdl|
				median = Median.find_or_initialize_by({name: mdl})
				dates.each do |key, value|
					median.send("median_ratio#{key}=", avg_stay_alive(mdl, key, value))
				end
				median.save
			end
		end
		LOG.info "生成留存率中位数完成，耗时#{sec.to_i}s"
	end
 	private
		def avg_stay_alive mdl, key, value
			model_class = mdl.constantize
			records = model_class.avg_stay_alive(key, value).map(&:avg_stay_alive)
			records.delete(0)
			records.blank? ? nil : records.median
		end

		def date_range date, type
			dates = {}
			dates[2] = date.send(type, 1.days).to_date
			dates[3] = date.send(type, 2.days).to_date
			dates[7] = date.send(type, 6.days).to_date
			dates[15] = date.send(type, 14.days).to_date
			dates[30] = date.send(type, 29.days).to_date
			dates
		end

end
