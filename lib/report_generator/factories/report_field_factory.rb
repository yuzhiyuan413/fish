module ReportGenerator
  module Factories
    class ReportFieldFactory < BaseFactory

      def initialize
        super
        self.attributes[:section_columns] = []
        self.attributes[:add_column] = {}
        self.attributes[:exprs] = []
      end

      def section name
        self.attributes[:section] = name
      end

      def column column_name
        self.attributes[:section_columns] << column_name
      end

      def columns *args
        self.attributes[:section_columns] += args
      end

      def add_column key, val
        self.attributes[:add_column] = {key => val}
      end

      def expr *args
        self.attributes[:field_type] = :expr_field
        self.attributes[:exprs] += args
      end

    end
  end
end
