module ReportGenerator
  module Models
    class Section < BaseModel
      include ReportGenerator::Helpers::QueryBuilder
      include ReportGenerator::Helpers::Descartes
      include ReportGenerator::Helpers::Common
      include ReportGenerator::Logging
      attr_accessor :name, :data_source, :select_columns, :joins, :conditions,
      :group_columns, :sum_groups, :sql_statement

      def perform
        logger.info "Current Section: #{name}"
        if sql_statement.present?
          query_with_sql
        else
          query_with_attrs
        end
      end # def perform

      private
      def query_with_sql
        logger.info "Query SQL: #{@sql_statement}"
        mysql_results = @data_source.connection.execute(@sql_statement)
        logger.info "Query Completed, Row Size: #{mysql_results.size}"
        result_fields = mysql_results.fields
        mysql_results.collect do |row|
          result_row = OpenStruct.new
          result_fields.each_with_index do |field, index|
            result_row.send("#{field}=", row[index])
          end
          result_row
        end
      end

      def query_with_attrs
        records = query(@data_source, @select_columns, @joins, @conditions, @group_columns)
        if sum_groups.present?
          logger.info "Starts to generate the records of sum group."
          items = gen_sum_group_items(records)
          sum_records = items.collect do |item|
            result = query(@data_source, item[:select_columns], @joins, item[:conditions], item[:group_columns])
            result.collect do |r|
              OpenStruct.new(r.attributes.dup.merge!(item[:labels]))
            end
          end # items.collect
          records += sum_records.flatten
        end # if sum_groups.present?
        records
      end

      def distribute_sum_groups records
        {}.tap do |x|
          @sum_groups.each do |column_name, distributer|
            x[column_name] = distributer.distribute(
              fetch_uniq_column_value(records, column_name))
          end
        end
      end

      def gen_column_combination
        (1..@sum_groups.keys.size).collect{ |i|
          @sum_groups.keys.combination(i).to_a }.flatten(1)
      end

      def gen_sum_group_items records
        distributed_groups = distribute_sum_groups(records)
        column_combination = gen_column_combination
        result = []
        column_combination.each do |column_names|
          tmp_group_columns, tmp_select_columns = group_columns.dup, select_columns.dup
          tmp_group_columns -= column_names
          tmp_select_columns -= column_names
          column_sets = column_names.collect{|i| distributed_groups[i]}
          descartes_sets = gen_descartes(column_names, column_sets)
          descartes_sets.each do |ds|
            tmp_conditions = @conditions.dup
            labels = {}
            ds.each do |column_name, sum_group|
              unless sum_group.members.nil?
                tmp_conditions << {column_name => sum_group.members}
              end
              # Name of the sum group
              tmp_column_name = column_name.to_s.split('.').last.to_sym
              labels[tmp_column_name] = sum_group.label
            end
            result << {
              select_columns: tmp_select_columns,
              group_columns: tmp_group_columns,
              conditions: tmp_conditions,
              labels: labels
            }
          end # descartes_sets.each
        end # column_combination.each
        result
      end # def gen_sum_group_items

    end
  end
end
