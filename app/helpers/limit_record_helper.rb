module LimitRecordHelper

  def devided_by_count(numerator,denominator)
    denominator == 0 ? 0 : numerator.to_f/denominator.to_f
  end

  def update_solution_succ_proportion_ratio(date)
    succ_proportion_ratio_sql = <<-EOF
      update seed_solution_reports a,
      (select tag,success_count from seed_solution_reports
      where report_date = '#{date.to_s}' and plan_id = 0 ) b
      set a.succ_proportion_ratio = (a.success_count/b.success_count)
      where a.report_date = '#{date.to_s}' and a.tag = b.tag
    EOF
    conn = ActiveRecord::Base.establish_connection(Rails.env).connection
    conn.execute succ_proportion_ratio_sql
  end

  def brand_limit_records(records, key, name, other_top)
    other_group_name = "其他#{name}"
    group_name_sum = "#{name}汇总"
    records = records.collect{|k,v| k.merge!(v)}.group_by{|item| {:tag=>item[:tag]}}
    result = {}.tap do |t|
      records.each do |tag, list|
        if list.present?
          sort_list = list.sort_by{|item|item[:count]}
          sum_brand_count = sort_list.map{|item|item[:count]}.compact.inject(0){|r,ele| r+ele}
          sum_brand_succ_count = sort_list.map{|item|item[:success_count]}.compact.inject(0){|r,ele| r+ele}
          sum_proportion_ratio = sum_brand_count == 0 ? 0 : 1
          sum_succ_proportion_ratio  = sum_brand_succ_count == 0 ? 0 : 1 
          sum_brand = {report_date: sort_list[0][:report_date], tag: sort_list[0][:tag]}
          sum_brand[key] = group_name_sum
          t[sum_brand] = {:count => sum_brand_count,:success_count => sum_brand_succ_count, :success_ratio => devided_by_count(sum_brand_succ_count,sum_brand_count), :proportion_ratio =>sum_proportion_ratio,:succ_proportion_ratio=>sum_succ_proportion_ratio}
          top_list = sort_list.pop(other_top)
          other_list_count = sort_list.blank? ? 0 : sort_list.map{|item|item[:count]}.compact.inject(0){|r,ele| r+ele}
          other_list_succ_count = sort_list.blank? ? 0 : sort_list.map{|item|item[:success_count]}.compact.inject(0){|r,ele| r+ele}
          top_list.each do |top_item|
            count = top_item.delete(:count)
            s_count = top_item.delete(:success_count)
            s_count = s_count.nil? ? 0 : s_count
            proportion_ratio = devided_by_count(count,sum_brand_count)
            succ_proportion_ratio  = devided_by_count(s_count,sum_brand_succ_count)
            t[top_item] = {:count => count,:success_count => s_count, :success_ratio => devided_by_count(s_count,count), :proportion_ratio =>proportion_ratio,:succ_proportion_ratio=>succ_proportion_ratio}
          end
          tmp_other_brand = sum_brand.dup
          tmp_other_brand[key] = other_group_name
          other_proportion_ratio = devided_by_count(other_list_count,sum_brand_count)
          other_succ_proportion_ratio = devided_by_count(other_list_succ_count,sum_brand_succ_count)
          t[tmp_other_brand] = {:count => other_list_count, :success_count => other_list_succ_count, :success_ratio => devided_by_count(other_list_succ_count,other_list_count), :proportion_ratio =>other_proportion_ratio,:succ_proportion_ratio=>other_succ_proportion_ratio}
        end
      end
    end
    result
  end
end
