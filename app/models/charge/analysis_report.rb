class Charge::AnalysisReport
  include RatioHelper
  attr_accessor :code_number, :dest_number, :province_id, :city_id,
                :operator_id, :sp_id, :current_tag, :unit, :start_date, :end_date,
                :business_coding, :sp_company, :code_union_name_flag, :report_date_flag

  ANALYSIS_REPORT_MDL = Struct.new(
    :report_date, :code_union_name, :province, :city, :operator,
    :business_coding, :sp_name, :sp_company, :current_tag, :activity_num,
    :deliver_num, :feedback_num, :sp_feedback_num, :deliver_ratio,
    :feedback_radio, :sp_feedback_ratio)

  REPORT_NORMAL_FORM_FIELDS = [:province_id, :city_id, :operator_id, :sp_id,
    :current_tag, :business_coding]

  REPORT_COUNT_FIELDS = {
    10 => :deliver_num,
    20 => :feedback_num,
    30 => :sp_feedback_num
  }
  COUNT_COLUMNS = {
    "1" => "COUNT(DISTINCT uuid) num",
    "2" => "COUNT(uuid) num",
    "3" => "SUM(amount) num"
  }
  ANALYSIS_REPORTS_CACHE_KEY = "charge_analysis"

  def initialize params = {}
    params.each { |k, v| self.send("#{k}=", v) } unless params.blank?
  end

  def search
    grouped_records = group_records(section_deliver_feedback)
    grouped_records.collect do |group_attrs, grouped_records|
      ANALYSIS_REPORT_MDL.new.tap do |r|
        group_attrs.each do |k,v|
          r.send("#{k}=", v)
        end
        grouped_records.each do |record|
          r.send("#{REPORT_COUNT_FIELDS[record.code_event]}=", record.num)
        end
        r.feedback_radio = ratio(r.feedback_num, r.deliver_num)
        r.sp_feedback_ratio = ratio(r.sp_feedback_num, r.feedback_num)
      end # ANALYSIS_REPORT_MDL.new.tap
    end
  end

  def sum_record records
    return nil if records.blank?
    ANALYSIS_REPORT_MDL.new.tap do |r|
      r.activity_num = records.map(&:activity_num).compact.sum
      r.deliver_num = records.map(&:deliver_num).compact.sum
      r.feedback_num = records.map(&:feedback_num).compact.sum
      r.sp_feedback_num = records.map(&:sp_feedback_num).compact.sum
      r.deliver_ratio = ratio(r.deliver_num, r.activity_num)
      r.feedback_radio = ratio(r.feedback_num, r.deliver_num)
      r.sp_feedback_ratio = ratio(r.sp_feedback_num, r.feedback_num)
    end
  end

  private
  def section_deliver_feedback
    ChargeDs::CodeHistory.select(select_clauses).where(
      where_conditions).group(group_clauses)
  end

  def group_records records
    city_maps = PandaDs::City.city_options
    province_maps = PandaDs::City.province_options
    operator_maps = PandaDs::City.operator_options
    sp_maps = SmartDs::ServiceProvider.sp_options
    business_coding_map = SmartDs::CodeBusinessType.map
    records.group_by do |r|
      province_id = r.try(:province_id) ? r.province_id.to_s : @province_id
      city_id = r.try(:city_id) ? r.city_id.to_s : @city_id
      operator_id = r.try(:operator_id) ? r.operator_id.to_s : @operator_id
      sp_id = r.try(:sp_id) ? r.sp_id.to_s : @sp_id
      business_coding = r.try(:business_coding) ? r.business_coding.to_s : @business_coding
      {
        report_date: r.try(:dt) ? r.dt.to_s : "所选时间段",
        province: province_maps[province_id],
        city: city_maps[city_id] || "全部",
        operator: operator_maps[operator_id],
        sp_name: sp_maps[sp_id],
        business_coding: business_coding_map[business_coding],
        code_union_name: r.try(:code_union_name) || "全部",
        sp_company: r.try(:sp_company) || "全部",
        current_tag: r.try(:current_tag) || "全部"
      }
    end
  end

  def select_clauses
    result = [].tap do |x|
      x << "date(server_time) dt" if report_date_flag?
      x << "code_union_name" if code_union_name_flag?
      x << "code_event"
      x << COUNT_COLUMNS[@unit]
    end
    result += normal_group_keys
  end

  def group_clauses
    result = [].tap do |x|
      x << "dt" if report_date_flag?
      x << "code_union_name" if code_union_name_flag?
      x << "code_event"
    end
    result += normal_group_keys
  end

  def where_conditions
    result = normal_form_condition_attrs.tap do |x|
      x["code_number"] = @code_number if @code_number.present?
      x["dest_number"] = @dest_number if @dest_number.present?
      x["server_time"] = (begin_time..end_time)
    end
  end

  def begin_time
    Date.parse(self.start_date).beginning_of_day
  end

  def end_time
    Date.parse(self.end_date).end_of_day
  end

  def report_date_flag?
    @report_date_flag == "true" ? true : false
  end

  def code_union_name_flag?
    @code_union_name_flag == "true" ? true : false
  end

  def normal_form_attrs
    {}.tap do |x|
      REPORT_NORMAL_FORM_FIELDS.each do |attr|
        x[attr] = self.send(attr) if (self.send(attr).present? && self.send(attr) != "all")
      end
    end
  end

  def normal_group_keys
    normal_form_attrs.select{|k,v| v == '0'}.keys
  end

  def normal_form_condition_attrs
    normal_form_attrs.select{|k,v| v != '0'}
  end
end
