module Dock
  module Warehouse
    class JobBase
      include Logging
      include JobHelper

      def initialize attrs=nil
        set_attrs(attrs) unless attrs.nil?
      end

      def set_attrs attrs
        attrs.each{ |k,v| self.send("#{k}=",v)}
      end

    end
  end
end
