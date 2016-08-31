class ReportEngines::ReportEngine
  attr_accessor :report_dates

  def initialize
    @report_dates = DateAnalyzer.new(ENV["date"]).get
  end

  def perform key, build_type=:reports
      LOG.info "#{key} 开始生成 "
      sec = Benchmark.realtime do
        report_dates.each do |report_date|
          ENV["report_date"] = report_date.to_s
          load_configuration
          if build_type == :reports
            LOG.info "#{key} 报表生成日期: #{report_date.to_s}"
            ReportGenerator.build(:reports, key).perform
          else
            LOG.info "#{key} 报表生成日期: #{report_date.to_s}"
            ReportGenerator.build_group(:reports, key).map &:perform
          end
        end
      end
      LOG.info "#{key} 结束生成, 耗时#{sec.to_i}s"
  end

  private
  def load_configuration
    `find #{Rails.root}/app/generators/ -name '*.rb'`.split.each{|file_path| load(file_path) }
  end

end
