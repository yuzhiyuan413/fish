class Distributers::TagDistributer

  def self.distribute items = []
    tmp_items = System::TagGroup.distribute(items)
    tmp_items.collect do |item|
      sum_group = ReportGenerator::Models::SumGroup.new(item.shift)
      sum_group.members = item unless item.compact.blank?
      sum_group
    end
  end
end
