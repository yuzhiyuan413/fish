class Distributers::ChargeTagDistributer
  
  TOTAL_SUM_TAG= '全部标签'

  def self.distribute items = []
    [ReportGenerator::Models::SumGroup.new(TOTAL_SUM_TAG)]
  end
end
