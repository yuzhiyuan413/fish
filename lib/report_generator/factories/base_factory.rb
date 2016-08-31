module ReportGenerator
  module Factories
    class BaseFactory
      attr_accessor :attributes

      def initialize
        @attributes = {}
      end

      def params key
        case key when :date
          ENV["report_date"].blank? ? Date.today : Date.parse(ENV["report_date"]) 
        else
          ENV[key]
        end
      end

      def method_missing(name, *args, &block)
        if args.size > 1
          @attributes[name] = args
        else
          @attributes[name] = args[0]
        end
      end
    end
  end
end
