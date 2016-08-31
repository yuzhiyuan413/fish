module ReportGenerator
  module Helpers
    module Descartes
      def gen_descartes column_names, column_sets
        unless column_names.size == column_sets.size
          raise "the column names does't match the column sets"
        end
        result = column_sets.shift
        while not column_sets.empty?
          arry_a = column_sets.shift
          result = descartes(result, arry_a);
        end
        result.collect do |r|
          {}.tap do |x|
            if column_names.size == 1
              x[column_names.first] = r
            else
              r.flatten!
              r.each_with_index{|val,idx| x[column_names[idx]] = val }
            end
          end
        end
      end

      def descartes arry_a, arry_b
        [].tap do |result|
          arry_a.each do |x|
            arry_b.each do |y|
              result << [x,y]
            end
          end
        end
      end

    end
  end
end
