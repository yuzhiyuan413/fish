module ReportGenerator
  module Helpers
    module ParameterParser
      def parse_report_date
        env_val = ENV["report_date"]
        regx_normal_date = /\d{4}-\d{2}-\d{2}/
        regx_date_range = /(?<begin_date>(\d{4}-\d{2}-\d{2}))\.\.(?<end_date>(\d{4}-\d{2}-\d{2}))/
        regx_last_day = /last(?<day_num>(\d+))days/
        regx_last_month = /last(?<day_num>(\d+))month/

        case env_val when regx_normal_date
          Date.parse($1)
        when regx_date_range
          (Date.parse($1)..Date.parse($2)).to_a
        when regx_last_day
          (Date.yesterday.ago($1.to_i)..Date.yesterday).to_a
        when regx_last_month
          (Date.yesterday.ago($1.to_i)..Date.yesterday).to_a
        else
          Date.today
        end
      end

    end
  end
end
