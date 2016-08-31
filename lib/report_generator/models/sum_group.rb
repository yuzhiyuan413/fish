module ReportGenerator
  module Models
    class SumGroup
      attr_accessor :label, :members

      def initialize label, members = nil
        @label, @members = label, members
      end
    end
  end
end
