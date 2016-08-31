module ReportGenerator
  module Helpers
    module QueryBuilder
      def query data_source, select_columns, joins, conditions, group_columns
        result = data_source
        result = data_source.select(select_columns) if select_columns.present?
        joins.each{|x| result = result.joins(x)}
        conditions.each{|x| result = result.where(x)}
        result.group(group_columns)
      end

      def clear data_source, condition
        data_source.destroy_all(condition)
      end

    end
  end
end
