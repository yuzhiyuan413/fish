class Command::GenerateApkMd5AlarmsRecord < Command::CommandCenter

	def run
		sec = Benchmark.realtime do
			begin_time = Seed::SeedApkMd5Alarm.maximum(:record_time).to_s(:db),
			sql = <<-EOF
				insert into seed_apk_md5_alarms
				select id, uid, tag, samd, record_time, created_at, updated_at
				from seed_request_histories
				where record_time > '#{begin_time}'
				and samd not in (select distinct md5 from package_infos);
			EOF
			ActiveRecord::Base.establish_connection(
				"dwh_smart_#{Rails.env}".to_sym).connection.execute(sql)
		end
		LOG.info "生成包篡改记录完成，耗时#{sec.to_i}s"
	end

end
