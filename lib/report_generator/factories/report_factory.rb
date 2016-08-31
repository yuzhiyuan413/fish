module ReportGenerator
  module Factories
    class ReportFactory < BaseFactory
      def initialize
        super
        self.attributes[:initialize_fields] = {}
        self.attributes[:report_fields] = []
        self.attributes[:expr_fields] = {}
        self.attributes[:extra_fields] = {}
        self.attributes[:clear_table_conditions] = {}
        self.attributes[:blocks] = {}
      end

      def initialize_fields *args, &block
        if args.present?
          args.each{|x| self.attributes[:initialize_fields][x]}
        end
        if block_given?
          attrs_factory = AttrsFactory.new
          attrs_factory.instance_eval(&block)
          self.attributes[:initialize_fields].merge!(attrs_factory.attributes)
        end
      end

      def field *names, &block
        field_factory = ReportGenerator::Factories::ReportFieldFactory.new
        field_factory.instance_eval(&block) if block_given?
        self.attributes[:report_fields] << {names => field_factory.attributes}
        self.attributes[:expr_fields][names] = field_factory.attributes[:exprs]
      end

      def clear_table &block
        if block_given?
          attrs_factory = AttrsFactory.new
          attrs_factory.instance_eval(&block)
          self.attributes[:clear_table_conditions].merge!(attrs_factory.attributes)
        end
      end

      def before_save &block
        self.attributes[:blocks][:before_save] = block.to_proc
      end

      def after_save &block
        self.attributes[:blocks][:after_save] = block.to_proc
      end

      def method_missing(name, *args, &block)
        self.attributes[name] = args[0]
      end

    end
  end
end
