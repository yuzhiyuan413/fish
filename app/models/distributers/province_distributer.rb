class Distributers::ProvinceDistributer

  TOTAL_SUM_PROVINCE = '全部省份'

  def self.distribute items = []
    [ReportGenerator::Models::SumGroup.new(TOTAL_SUM_PROVINCE)]
  end

end
