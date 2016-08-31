# -*- encoding : utf-8 -*-
class Seed::LostReport
  include RatioHelper
  attr_accessor :group_field, :event_process, :base_start_time,
    :base_stop_time, :compare_start_time, :compare_stop_time, :compare_flag,
    :plan_id, :tag
  STRUCT_LOST_REPORT = Struct.new(:group_field, :group_field1,:base_event_num,
    :compare_event_num, :event_lost_num, :lost_ratio)
  STRUCT_COMPARE_REPORT = Struct.new(:group_field,:group_field1, :base_event_num,
    :compare_event_num, :event_lost_num, :lost_ratio, :base_event_num2,
    :compare_event_num2, :event_lost_num2, :lost_ratio2, :lost_compare_ratio)
  GROUP_FIELDS_MAP = {
    '1' => ["tag"],
    '2' => ["api_level"],
    '3' => ["linux_version_short"],
    '4' => ["brand"],
    '5' => ["brand","model"]
  }
  PROCESS_EVENTS = {
    '1' => [:active, :solution_executing],
    '2' => [:solution_executing, :solution_executed],
    '3' => [:solution_executed, :solution_successed],
    '4' => [:solution_successed, :solution_installed]
  }
  EVENT_CONDITIONS = {
    :active => { :event_name => "active" },
    :solution_executing => { :event_name => "solution_executing" },
    :solution_executed => { :event_name => "solution_executed" },
    :solution_successed => { :excuted_status => "Success" },
    :solution_installed => { :nut_code => [0,16,17,2,4]}
  }
  FIELD_NAME_MAP = {
   [0,0] => 'base_event_num',
   [1,0] => 'compare_event_num',
   [0,1] => 'base_event_num2',
   [1,1] => 'compare_event_num2'
  }

  def initialize params = {}
    params.each{|k,v| self.send("#{k}=",v)} unless params.blank?
  end

  def search
    report
  end

  def sum_record
  end

  def compare?
    @compare_flag == '1' ? true : false
  end

  private
  def report
    args = []
    time_ranges = compare? ? [base_time_range, compare_time_range] :
      [base_time_range]
    PROCESS_EVENTS[@event_process].each_with_index do |event_name, index|
      time_ranges.each_with_index do |tr, idx|
        args << {}.tap do |arg|
          arg[:event_name] = event_name
          arg[:time_range] = tr
          arg[:field_name] = FIELD_NAME_MAP[[index, idx]]
        end
      end
    end
    section_records = args.collect do |arg|
      section_event(arg[:event_name], arg[:time_range]).collect do |r|
        {}.tap do |x|
          group_field_name.each {|group_name| x[group_name] = r.send(group_name)}
          x[arg[:field_name]] = r.send('did_count')
        end
      end
    end

    grouped_records = section_records.flatten.group_by do |r|
      {}.tap do |x|
        group_field_name.each{|group_name| x[group_name] = r[group_name]}
      end
    end 
    grouped_records.values.collect do |records|
      merged_record = records.inject(&:merge)
      r = compare? ? STRUCT_COMPARE_REPORT.new : STRUCT_LOST_REPORT.new
      group_field_name.each_with_index do |group_name, index|
        if index == 1
          r.send("group_field#{index}=",merged_record[group_name]) 
        else
          r.group_field = merged_record[group_name]
        end     
      end
      r.base_event_num = merged_record['base_event_num']
      r.compare_event_num = merged_record['compare_event_num']
      r.event_lost_num = r.base_event_num.to_i - r.compare_event_num.to_i
      r.lost_ratio = ratio(r.event_lost_num, r.base_event_num)
      if compare?
        r.base_event_num2 = merged_record['base_event_num2']
        r.compare_event_num2 = merged_record['compare_event_num2']
        r.event_lost_num2 = r.base_event_num2.to_i - r.compare_event_num2.to_i
        r.lost_ratio2 = ratio(r.event_lost_num2, r.base_event_num2)
        r.lost_compare_ratio = r.lost_ratio - r.lost_ratio2
      end
      r
    end

  end

  def section_event event_name, time_range
    conditions = EVENT_CONDITIONS[event_name].dup
    conditions[:solution_id] = @plan_id unless @plan_id == "全部方案"
    conditions[:tag] = @tag unless @tag == "全部标签"
    data_source = time_range.to_a[0][0,10] == Date.today.to_s ?
      DailyDs::SeedFeedbackHistory : SwordDs::SeedFeedbackHistory
    select_columns = [group_field_name,"count(distinct did) did_count"].flatten
    data_source.select(select_columns).where(record_time: time_range
      ).where(conditions).group(group_field_name)
  end

  def base_time_range
    ("#{@base_start_time}:00".."#{@base_stop_time}:59")
  end

  def compare_time_range
    ("#{@compare_start_time}:00".."#{@compare_stop_time}:59")
  end

  def group_field_name
    GROUP_FIELDS_MAP[@group_field]
  end

end
