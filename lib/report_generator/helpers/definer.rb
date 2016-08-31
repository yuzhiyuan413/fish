module ReportGenerator
  module Helpers
    module Definer

      def section name, &block
        section_factory = ReportGenerator::Factories::SectionFactory.new
        section_factory.instance_eval(&block) if block_given?
        ReportGenerator.add_section_factory(name, section_factory)
      end

      def report name, &block
        report_factory = ReportGenerator::Factories::ReportFactory.new
        report_factory.instance_eval(&block) if block_given?
        ReportGenerator.add_report_factory(name, report_factory, :default)
      end

      def group name, &block
        group_factory = ReportGenerator::Factories::GroupFactory.new
        group_factory.instance_eval(&block) if block_given?
        ReportGenerator.add_group_factory(name, group_factory)
      end

    end
  end
end
