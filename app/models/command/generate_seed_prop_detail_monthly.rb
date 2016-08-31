class Command::GenerateSeedPropDetailMonthly < Command::CommandCenter
  OTHERS_MODEL_NAME = '其他型号'
  SUMMARY_MODEL_NAME = '型号汇总'
  TOP_COUNT_LIMIT = 200

  attr_accessor :top_models

  def initialize
    @top_models = {}
  end

  def run
    clean_overdue_data

    ActiveRecord::Base.transaction do
      save_count_reports(prop_detail_records.group_by(&:tag))
    end
    grouped_count_records={}
    summary_tags = System::TagGroup.distribute(Seed::PropDetailMonthlyReport.tags)
    summary_tags.each do |tag|
      tag_name = tag.is_a?(Array) ? tag.shift : tag
      grouped_count_records[tag_name] = prop_detail_records_by_tag_group(tag)
    end
    ActiveRecord::Base.transaction do
      save_count_reports(grouped_count_records)
    end

    ActiveRecord::Base.transaction do
      prop_sum_records.each do |record|
        r = Seed::PropDetailMonthlyReport.find_or_initialize_by({
          report_date: report_date.strftime("%Y/%m"),
          tag: record.tag,
          manufacturer: nil,
          board: SUMMARY_MODEL_NAME
        })
        r.count = record.did_count
        r.save
      end
    end
    summary_tags = System::TagGroup.distribute(Seed::PropDetailMonthlyReport.tags)
    ActiveRecord::Base.transaction do
      summary_tags.each do |tag|
        tag_name = tag.is_a?(Array) ? tag.shift : tag
        r = Seed::PropDetailMonthlyReport.find_or_initialize_by({
          report_date: report_date.strftime("%Y/%m"),
          tag: tag_name,
          manufacturer: nil,
          board: SUMMARY_MODEL_NAME
        })
        r.count = count_prop_sum_by_tag_group(tag)
        r.save
      end
    end

    ActiveRecord::Base.transaction do
      save_succ_count_reports(prop_detail_succ_records.group_by(&:tag))
    end
    grouped_succ_count_records={}
    summary_tags = System::TagGroup.distribute(Seed::PropDetailMonthlyReport.tags)
    summary_tags.each do |tag|
      tag_name = tag.is_a?(Array) ? tag.shift : tag
      grouped_succ_count_records[tag_name] = prop_detail_succ_records_by_tag_group(tag)
    end
    ActiveRecord::Base.transaction do
      save_succ_count_reports(grouped_succ_count_records)
    end

    ActiveRecord::Base.transaction do
      prop_succ_sum_records.each do |record|
        r = Seed::PropDetailMonthlyReport.find_or_initialize_by({
          report_date: report_date.strftime("%Y/%m"),
          tag: record.tag,
          manufacturer: nil,
          board: SUMMARY_MODEL_NAME
        })
        r.success_count = record.did_count
        r.save
      end
    end

    summary_tags = System::TagGroup.distribute(Seed::PropDetailMonthlyReport.tags)
    ActiveRecord::Base.transaction do
      summary_tags.each do |tag|
        tag_name = tag.is_a?(Array) ? tag.shift : tag
        r = Seed::PropDetailMonthlyReport.find_or_initialize_by({
          report_date: report_date.strftime("%Y/%m"),
          tag: tag_name,
          manufacturer: nil,
          board: SUMMARY_MODEL_NAME
        })
        r.success_count = count_prop_succ_sum_by_tag_group(tag)
        r.save
      end
    end

    succ_proportion_ratio_sql = <<-EOF
      update seed_prop_detail_monthly_reports a,
      (select tag, count, success_count from seed_prop_detail_monthly_reports
      where report_date = '#{report_date.strftime("%Y/%m")}' and board = '#{SUMMARY_MODEL_NAME}') b
      set a.succ_proportion_ratio = (a.success_count/b.success_count),
      a.proportion_ratio = (a.count/b.count)
      where a.report_date = '#{report_date.strftime("%Y/%m")}' and a.tag = b.tag
    EOF
    success_ratio_sql = <<-EOF
      update seed_prop_detail_monthly_reports
      set success_ratio = (success_count/count)
      where report_date = '#{report_date.strftime("%Y/%m")}'
    EOF
    conn = ActiveRecord::Base.establish_connection(Rails.env).connection
    conn.execute succ_proportion_ratio_sql
    conn.execute success_ratio_sql

    System::TagGroup.reset_tags_options_cache(Seed::PropDetailMonthlyReport,
    System::Constant::PICK_OPTIONS[Seed::PropDetailMonthlyReport])
  end


  private
    def clean_overdue_data
      Seed::PropDetailMonthlyReport.destroy_all(:report_date => report_date.strftime("%Y/%m"))
    end

    def save_count_reports grouped_count_records
      grouped_count_records.each do |tag, records|
        sorted_records = records.sort_by(&:did_count)
        top_records = []
        sorted_records.each do |record|
          top_records << sorted_records.pop if record.did_count >= TOP_COUNT_LIMIT
        end
        top_models[tag] = top_records.collect{|x| [x.ro_pd_brand, x.ro_pd_model].join}
        others_sum_count = sorted_records.blank? ? 0  : sorted_records.map(&:did_count).compact.sum
        top_records.each do |record|
          r = Seed::PropDetailMonthlyReport.find_or_initialize_by({
            report_date: report_date.strftime("%Y/%m"),
            tag: tag,
            manufacturer: record.ro_pd_brand,
            board: record.ro_pd_model
          })
          r.count = record.did_count
          r.save
        end
        r = Seed::PropDetailMonthlyReport.find_or_initialize_by({
          report_date: report_date.strftime("%Y/%m"),
          tag: tag,
          manufacturer: nil,
          board: OTHERS_MODEL_NAME
        })
        r.count = others_sum_count
        r.save
      end
    end

    def save_succ_count_reports grouped_succ_count_records
      grouped_succ_count_records.each do |tag, records|
        top_records = []
        other_records = []
        records.each do |r|
          if top_models[tag].include?([r.ro_pd_brand, r.ro_pd_model].join)
            top_records << r
          else
            other_records << r
          end
        end
        others_sum_count = other_records.blank? ? 0  : other_records.map(&:did_count).compact.sum
        top_records.each do |record|
          r = Seed::PropDetailMonthlyReport.find_or_initialize_by({
            report_date: report_date.strftime("%Y/%m"),
            tag: tag,
            manufacturer: record.ro_pd_brand,
            board: record.ro_pd_model
          })
          r.success_count = record.did_count
          r.save
        end
        r = Seed::PropDetailMonthlyReport.find_or_initialize_by({
          report_date: report_date.strftime("%Y/%m"),
          tag: tag,
          manufacturer: nil,
          board: OTHERS_MODEL_NAME
        })
        r.success_count = others_sum_count
        r.save
      end
    end

    def prop_detail_records_by_tag_group(tag)
      SwordDs::Prop.prop_detail_records_by_tag_group(tag,
        report_date.beginning_of_month.beginning_of_day,
        report_date.end_of_month.end_of_day)
    end

    def prop_detail_records
      SwordDs::Prop.prop_detail_records(
        report_date.beginning_of_month.beginning_of_day,
        report_date.end_of_month.end_of_day)
    end

    def count_prop_sum_by_tag_group(tag)
      SwordDs::Prop.count_prop_sum_by_tag_group(tag,
        report_date.beginning_of_month.beginning_of_day,
        report_date.end_of_month.end_of_day)
    end

    def prop_sum_records
      SwordDs::Prop.prop_sum_records(
        report_date.beginning_of_month.beginning_of_day,
        report_date.end_of_month.end_of_day)
    end


    def prop_detail_succ_records
      SwordDs::Prop.prop_detail_succ_records(
        report_date.beginning_of_month.beginning_of_day,
        report_date.end_of_month.end_of_day)
    end

    def prop_detail_succ_records_by_tag_group(tag)
      SwordDs::Prop.prop_detail_succ_records_by_tag_group(tag,
        report_date.beginning_of_month.beginning_of_day,
        report_date.end_of_month.end_of_day)
    end

    def count_prop_succ_sum_by_tag_group(tag)
      SwordDs::Prop.count_prop_succ_sum_by_tag_group(tag,
        report_date.beginning_of_month.beginning_of_day,
        report_date.end_of_month.end_of_day)
    end

    def prop_succ_sum_records
      SwordDs::Prop.prop_succ_sum_records(
        report_date.beginning_of_month.beginning_of_day,
        report_date.end_of_month.end_of_day)
    end

    def report_date
      Date.yesterday
    end
end
