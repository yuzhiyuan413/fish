module ReportGenerator
  module Factories
    class GroupFactory < BaseFactory

      def initialize
        super
        self.attributes[:reports] = {}
      end

      def report name, &block
        report_factory = ReportGenerator::Factories::ReportFactory.new
        report_factory.instance_eval(&block) if block_given?
        self.attributes[:reports][name] = report_factory
      end

    end
  end
end
