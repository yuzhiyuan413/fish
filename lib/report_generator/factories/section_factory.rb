module ReportGenerator
  module Factories
    class SectionFactory < BaseFactory

      def initialize
        super
        self.attributes[:select_columns] = []
        self.attributes[:conditions] = []
        self.attributes[:group_columns] = []
        self.attributes[:sum_groups] = {}
        self.attributes[:joins] = []
      end

      def mixin section_name, options = {}
        tmp_sf_attrs = ReportGenerator.section_factories[section_name].attributes.dup
        except_items = options[:except]
        if except_items
          except_mapping = {condition: :conditions,
                            group: :group_columns,
                            sum_group: :sum_groups,
                            join: :joins ,
                            count: {select_columns: "COUNT("},
                            distinct_count: {select_columns: " COUNT(DISTINCT "},
                            sum: {select_columns: "SUM("},
                            select: :select_columns,
                            data_source: :data_source}
          tmp_except_items = except_items.is_a?(Array) ? except_items : [except_items]
          tmp_except_items.each do |x|
            if except_mapping[x].class.equal?(Hash)
              tmp_sf_attrs[:select_columns].delete_if{|col| col.start_with?(except_mapping[x][:select_columns]) if col.class.equal?(String)}
            else
              tmp_sf_attrs[:select_columns].delete_if{|col| col.class.equal?(Symbol) }  if x.equal?(:group)
              tmp_sf_attrs.delete(except_mapping[x])
            end
          end
        end
        self.attributes.merge!(tmp_sf_attrs)
      end

      def data_source kclass
        self.attributes[:data_source] = kclass
      end

      def select *cols
        self.attributes[:select_columns] +=  cols
      end

      def count *cols
        self.attributes[:select_columns] += cols.collect do |x|
          "COUNT(#{x}) count_#{x.to_s.gsub('.', '_')}"
        end
      end

      def distinct_count *cols
        self.attributes[:select_columns] += cols.collect do |x|
          " COUNT(DISTINCT #{x}) count_distinct_#{x.to_s.gsub('.', '_')}"
        end
      end

      def sum *cols
        self.attributes[:select_columns] += cols.collect{|x| "SUM(#{x}) sum_#{x.to_s.gsub('.', '_')}"}
      end

      def condition *arg, &block
        self.attributes[:conditions]  += arg
        if block_given?
          attrs_factory = AttrsFactory.new
          attrs_factory.instance_eval(&block)
          self.attributes[:conditions] << attrs_factory.attributes
        end
      end

      def group *arg
        self.attributes[:select_columns] += arg
        self.attributes[:group_columns] += arg
      end

      def sum_group col, manager = nil
        self.attributes[:sum_groups][col] = manager
      end

      def join join_clause
        self.attributes[:joins] << join_clause
      end

      def execute sql
        self.attributes[:sql_statement] = sql
      end

    end
  end
end
