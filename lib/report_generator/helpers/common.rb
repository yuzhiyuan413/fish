module ReportGenerator
  module Helpers
    module Common
      def fetch_uniq_column_value records, column_name
        tmp_column_name = column_name.to_s.split('.').last.to_sym
        records.map(&tmp_column_name).uniq.compact
      end
    end
  end
end
