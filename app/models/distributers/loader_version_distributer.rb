class Distributers::LoaderVersionDistributer

  SUM_LOADERVERSION_POSTFIX = '版本汇总'
  TOTAL_SUM_LOADERVERSION = '全部版本'

  def self.distribute items = []
    grouped_versions = items.group_by{|item| item[0]}
    [].tap do |x|
      grouped_versions.each do |k,v|
        sum_group = ReportGenerator::Models::SumGroup.new(
          "#{k}#{SUM_LOADERVERSION_POSTFIX}", v)
        x << sum_group
      end
      x.unshift(ReportGenerator::Models::SumGroup.new(TOTAL_SUM_LOADERVERSION))
    end
  end

end
