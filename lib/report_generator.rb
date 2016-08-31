require 'ostruct'
require 'date'
require 'active_support/core_ext/module/attribute_accessors'

require 'report_generator/logging'
require 'report_generator/version'
require 'report_generator/base'
require 'report_generator/helpers/common'
require 'report_generator/helpers/descartes'
require 'report_generator/helpers/query_builder'
require 'report_generator/helpers/definer'
require 'report_generator/helpers/parameter_parser'
require 'report_generator/factories/base_factory'
require 'report_generator/factories/attrs_factory'
require 'report_generator/factories/report_field_factory'
require 'report_generator/factories/section_factory'
require 'report_generator/factories/report_factory'
require 'report_generator/factories/group_factory'
require 'report_generator/models/base_model'
require 'report_generator/models/sum_group'
require 'report_generator/models/report'
require 'report_generator/models/report_field'
require 'report_generator/models/section'

module ReportGenerator
  extend ReportGenerator::Helpers::Definer
  mattr_accessor :factories do
    { sections: {}, reports: {} }
  end

  class << self
    def add_report_factory report_name, report_factory, group_name = :default
      self.factories[:reports][group_name] ||= {}
      self.factories[:reports][group_name][:reports] ||= {}
      self.factories[:reports][group_name][:reports][report_name] = report_factory
    end

    def add_section_factory name, factory
      self.factories[:sections] ||= {}
      self.factories[:sections][name] = factory
    end

    def add_group_factory group_name, group_factory
      self.factories[:reports][group_name] = group_factory
    end

    def section_factories
      self.factories[:sections]
    end

    def report_factories group_name = :default
      self.factories[:reports][group_name][:reports]
    end

    def group_factories
      self.factories[:reports]
    end

    def exists_group? name
      group_factories.has_key?(name)
    end

    def exists_report? name
      section_factories.has_key?(name)
    end

    def exists_section? name
    end

    def configure &block
      class_eval(&block) if block_given?
    end

    def build model_type, model_name, group_name=:default, attributes = {}
      model_class = ReportGenerator::Models::Report
      tmp_factory_attributes = nil
      if model_type.equal?(:sections)
        model_class = ReportGenerator::Models::Section
        tmp_factory_attributes = section_factories[model_name].attributes
      else
        tmp_factory_attributes = report_factories[model_name].attributes
        model_name = tmp_factory_attributes[:report_model]
      end
      if attributes.present?
        tmp_factory_attributes.merge!(attributes)
      end
      tmp_model = model_class.new
      tmp_model.tap do |x|
        x.name = model_name
        tmp_factory_attributes.each do |k,v|
          x.send("#{k}=", v)
        end
      end
    end

    def build_group model_type, group_name
      reportfactories = group_factories[group_name].attributes[:reports]
      reportfactories.collect do |report_name,report_factory|
        tmp_factory_attributes = report_factory.attributes

        report_model = report_factory.attributes[:report_model]
        tmp_model = ReportGenerator::Models::Report.new
        tmp_model.tap do |x|
          x.name = report_model
          tmp_factory_attributes.each do |k,v|
            x.send("#{k}=", v)
          end
        end

      end

    end

  end
end
