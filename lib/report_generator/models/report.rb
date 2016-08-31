module ReportGenerator
  module Models
    class Report < BaseModel
      attr_accessor :name, :initialize_fields, :report_fields, :expr_fields,
      :extra_fields, :blank_init_fields, :fields_maps ,:report_model,
      :clear_table_conditions, :blocks
      include ReportGenerator::Helpers::QueryBuilder

      def perform
        logger.info "Current Report: #{@name}"
        clear_history
        prepare
        integration_records = integrate_sections
        logger.info "Integration Complete, Record Size: #{integration_records.size}"
        grouped_records = gen_grouped_records(integration_records)
        logger.info "Group Complete"
        merged_records = merge_grouped_records(grouped_records)
        logger.info "Merge Complete"
        result_records = gen_expr_fields(merged_records)
        logger.info "Expression Execute Complete"
        result_records = @blocks[:before_save].call(result_records) if @blocks.has_key?(:before_save)
        logger.info "Starts to store the records, Record Size: #{result_records.size}."
        save(result_records)
        logger.info "Store Complete."
        @blocks[:after_save].call if @blocks.has_key?(:after_save)
      end

      private
      def report_class
        @report_model
      end

      def gen_initialize_fields report_field_name, record
        result = @initialize_fields.dup
        result.tap do |x|
          @blank_init_fields.each_with_index do |blank_field_name, idx|
            x[blank_field_name] = record.send(@fields_maps[report_field_name][blank_field_name])
          end
        end
      end

      def init_blank_init_fields
        @blank_init_fields = @initialize_fields.collect{|k,v| k if v.blank?}.compact
      end

      def init_fields_maps
        @fields_maps = {}.tap do |x|
          @report_fields.each do |report_field|
            report_field.each do |report_field_name, report_field_attrs|
              tmp_report_fields = @blank_init_fields + report_field_name
              x[report_field_name] = {}
              tmp_report_fields.each_with_index do |field_name, idx|
                x[report_field_name][field_name] = report_field_attrs[:section_columns][idx]
              end
            end
          end
        end
      end

      def clear_history
        clear report_class, clear_table_conditions if @clear_table_conditions.present?
      end

      def prepare
        init_blank_init_fields
        init_fields_maps
      end

      def gen_grouped_records records
        records.group_by{|r| r[:init_fields]}
      end

      def merge_grouped_records grouped_records
        {}.tap do |x|
          grouped_records.each do |group_key, records|
            tmp_records = records.each{|x| x.delete(:init_fields)}
            x[group_key]=tmp_records.inject(&:merge)
          end
        end
      end


      def gen_expr_fields merged_records
        @expr_fields.each do |field_name, expr_ary|
          if expr_ary.count > 0
            statement = expr_ary.shift
            if statement.to_s.count('?') > 0
              merged_records.each do |init_fields, record_attrs|
                values = expr_ary.collect{|x| record_attrs[x].to_f}
                result_val =  values[1] == 0.0 ? 0.0 : eval(replace_bind_variables(statement, values))
                record_attrs[field_name.first] = result_val
                merged_records[init_fields] = record_attrs
              end
            end
          end
        end
        merged_records
      end


      def replace_bind_variables(statement, values) # :nodoc:
        raise_if_bind_arity_mismatch(statement, statement.count('?'), values.size)

        bound = values.dup

        statement.gsub(/\?/) do
          bound.shift
        end

      end

      def raise_if_bind_arity_mismatch(statement, expected, provided) # :nodoc:
        unless expected == provided
          raise PreparedStatementInvalid, "wrong number of bind variables (#{provided} for #{expected}) in: #{statement}"
        end
      end

      def integrate_sections
        result = []
        @report_fields.each do |report_field|
          result += report_field.collect do |field_name, field_attrs|
            if field_attrs[:section].present?
              section = ReportGenerator.build(:sections, field_attrs[:section])
              records = section.perform
              records.collect do |record|
                r = {}.tap do |x|
                  x[:init_fields] = gen_initialize_fields(field_name, record)
                  field_name.each{|fn| x[fn] = record.send(@fields_maps[field_name][fn])}
                  x.merge!(field_attrs[:add_column]) if field_attrs[:add_column].present?
                end
              end
            else
              []
            end
          end.flatten
        end
        return result
      end

      def save records
        ActiveRecord::Base.transaction do
          records.each do |init_fields, record_attrs|
            r = report_class.find_or_initialize_by(init_fields)
            record_attrs.each{|k,v| r.send("#{k}=",v) }
            r.save
          end
        end
      end

    end
  end
end
