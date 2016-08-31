Rails.cache.delete_matched("sidebar_*")

Pass::System.define_subsystem "种子报表" do |s|
  s.attributes :id => 10, :controller => "seed_activation_reports", :action => "left", :sort => "1", :hidden => 0, :icon_class => "fa fa-folder"

  s.define_function "用户概况" do |f|
    f.attributes :id => 11, :controller => "seed/activity_situation_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/activity_situation_reports", :description => "用户概况", :function_id => 11
  end

  s.define_function "活跃用户" do |f|
    f.attributes :id => 12, :controller => "seed/activity_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/activity_reports", :description => "活跃用户", :function_id => 12
  end

  s.define_function "新增用户" do |f|
    f.attributes :id => 13, :controller => "seed/activation_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/activation_reports", :description => "新增用户", :function_id => 13
  end

  s.define_function "留存用户" do |f|
    f.attributes :id => 14, :controller => "seed/alive_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/alive_reports", :description => "留存用户", :function_id => 14
  end

  s.define_function "方案执行" do |f|
    f.attributes :id => 15, :controller => "seed/solution_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/solution_reports", :description => "方案执行", :function_id => 15
  end

  s.define_function "流失分析" do |f|
    f.attributes :id => 21, :controller => "seed/lost_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/lost_reports", :description => "流失分析", :function_id => 21
  end

  s.define_function "终端厂商" do |f|
    f.attributes :id => 16, :controller => "seed/prop_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/prop_reports", :description => "终端厂商", :function_id => 16
  end

  s.define_function "终端属性" do |f|
    f.attributes :id => 17, :controller => "seed/prop_detail_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/prop_detail_reports", :description => "终端属性", :function_id => 17
  end


  s.define_function "系统参数-终端属性" do |f|
    f.attributes :id => 20, :controller => "seed/device_detail_reports", :action => "index", :sort => "10",  :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/device_detail_reports", :description => "系统参数-终端属性", :function_id => 20
  end


  s.define_function "终端属性月汇总" do |f|
    f.attributes :id => 18, :controller => "seed/prop_detail_monthly_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/prop_detail_monthly_reports", :description => "终端属性月汇总", :function_id => 18
  end

  s.define_function "种子全事件到达" do |f|
    f.attributes :id => 19, :controller => "seed/arrival_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/arrival_reports", :description => "基于种子AID激活用户的全事件到达情况", :function_id => 19
  end

end

Pass::System.define_subsystem "计费报表" do |s|
  s.attributes :id => 50, :controller => "charge_reports", :action => "left", :sort => "1", :hidden => 0, :icon_class => "fa fa-folder"

  s.define_function "计费概况" do |f|
    f.attributes :id => 56, :controller => "charge/situation_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "charge/situation_reports", :description => "计费概况", :function_id => 56
  end

  s.define_function "计费新增" do |f|
    f.attributes :id => 51, :controller => "charge/activation_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "charge/activation_reports", :description => "新增用户", :function_id => 51
  end

  s.define_function "计费活跃" do |f|
    f.attributes :id => 52, :controller => "charge/activity_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "charge/activity_reports", :description => "活跃用户", :function_id => 52
  end

  s.define_function "计费月报" do |f|
    f.attributes :id => 53, :controller => "charge/activity_month_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "charge/activity_month_reports", :description => "活跃月报", :function_id => 53
  end

  s.define_function "计费趋势" do |f|
    f.attributes :id => 54, :controller => "charge/activity_trend_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "charge/activity_trend_reports", :description => "活跃趋势", :function_id => 54
  end

  s.define_function "计费留存" do |f|
    f.attributes :id => 55, :controller => "charge/alive_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "charge/alive_reports", :description => "留存用户", :function_id => 55
  end
end

Pass::System.define_subsystem "易打工" do |s|
  s.attributes :id => 80, :controller => "ework/conversion_reports", :action => "left", :sort => "2", :hidden => 0, :icon_class => "fa fa-folder"

  s.define_function "事件转化率" do |f|
    f.attributes :id => 81, :controller => "ework/conversion_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "ework/conversion_reports", :description => "事件转化率", :function_id => 81
  end

  s.define_function "全业务线到达" do |f|
    f.attributes :id => 82, :controller => "ework/arrival_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "ework/arrival_reports", :description => "基于易打工每日激活用户的全业务线到达情况", :function_id => 82
  end
end

Pass::System.define_subsystem "异常分析" do |s|
  s.attributes :id => 70, :controller => "apk_md5_alarm_reports", :action => "left", :sort => "1", :hidden => 0, :icon_class => "fa fa-folder"
  #
  # s.define_function "篡改报表" do |f|
  #   f.attributes :id => 71, :controller => "seed/apk_md5_alarm_reports", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
  #   f.define_controller :name => "seed/apk_md5_alarm_reports", :description => "包篡改", :function_id => 71
  # end

  s.define_function "篡改查询" do |f|
    f.attributes :id => 72, :controller => "seed/seed_apk_md5_alarms", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "seed/seed_apk_md5_alarms", :description => "包篡改查询", :function_id => 72
  end
end

Pass::System.define_subsystem "系统管理" do |s|
  s.attributes :id => 30, :controller => "system/accounts", :action => "left", :sort => "1", :hidden => 0, :icon_class => "fa fa-folder"

  s.define_function "帐号管理" do |f|
    f.attributes :id => 31, :controller => "system/accounts", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "system/accounts", :description => "帐号管理", :function_id => 31
    f.define_controller :name => "system/functions", :description => "帐号功能模块", :function_id => 31
    f.define_controller :name => "system/permissions", :description => "帐号权限设置", :function_id => 31
    f.define_controller :name => "system/rate_manages", :description => "比例设置", :function_id => 31
  end

  s.define_function "角色管理" do |f|
    f.attributes :id => 32, :controller => "system/roles", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "system/roles", :description => "角色管理", :function_id => 32
  end

  s.define_function "发布日志" do |f|
    f.attributes :id => 33, :controller => "system/changes", :action => "index", :sort => "10", :hidden => 1, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "system/changes", :description => "发布日志", :function_id => 33
  end

  s.define_function "查看日志" do |f|
    f.attributes :id => 34, :controller => "system/logs", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "system/logs", :description => "发布日志", :function_id => 34
  end

  s.define_function "标签组" do |f|
    f.attributes :id => 35, :controller => "system/tag_groups", :action => "index", :sort => "10", :hidden => 0, :url => "", :icon_class => "fa fa-circle-o"
    f.define_controller :name => "system/tag_groups", :description => "标签组", :function_id => 35
  end
end

# Pass::System.define_subsystem "数据生成" do |s|
#   s.attributes :id => 36, :controller => "generator/generators_operate", :action => "left", :sort => "1", :hidden => 0

#   s.define_function "配置管理" do |f|
#     f.attributes :id => 37, :controller => "generator/generators_operate", :action => "files_name", :sort => "10", :hidden => 0, :url => ""
#     f.define_controller :name => "generator/generators_operate/files_name", :description => "配置管理", :function_id => 37
#   end
#   s.define_function "数据生成" do |f|
#     f.attributes :id => 38, :controller => "generator/generators_operate", :action => "index", :sort => "10", :hidden => 0, :url => ""
#     f.define_controller :name => "generator/generators_operate", :description => "数据生成", :function_id => 38
#   end
# end
