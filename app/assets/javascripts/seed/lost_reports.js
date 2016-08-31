function getModel(){
  var ItemModel =
    {
      tb_id: "base_lost_report_list",
      url:'/seed/lost_reports/index',
      attributes: {
          columnDefs: [{
            targets: [1],
            visible: false
          }],
          stateSave: false,//保存最后的操作状态
          order: [[ 4, "desc" ]]
      },
      params:{
          "seed_lost_report":{
              group_field:$("#group_field").val(),
              event_process:$("#event_process").val(),
              base_start_time:$("#base_start_time").val(),
              base_stop_time:$("#base_stop_time").val(),
              compare_start_time:$("#compare_start_time").val(),
              compare_stop_time:$("#compare_stop_time").val(),
              plan_id:$("#plan_id").val(),
              tag:$("#tag").val(),
              compare_flag:'0'

          }
      },
      set_class: function(el,item){
         return false;
      }
    }

    return ItemModel;
}
initForm();
new DeviceListView(getModel());
function getHiddenCols(){
    if($("#group_field").val() == "5") {
      return[];
    }
    else{
      return[1];
    }
}
group_mappings = {"1": ["Tag"],"2": ["Android API Level"],"3": ["Linux Version"],"4": ["Brand"],"5": ["Brand","Model"]}
event_mappings = {"1": ["种子联网","开始执行"],"2": ["开始执行","执行完成"],"3": ["执行完成","执行成功"],"4": ["执行成功","安装成功"]}

$(".lost_btn").on("click",function(){
    base_start_time = $("#base_start_time").val()
    base_stop_time = $("#base_stop_time").val()
    compare_start_time = $("#compare_start_time").val()
    compare_stop_time = $("#compare_stop_time").val()
    baseTimeRange = [base_start_time, base_stop_time]
    compareTimeRange = [compare_start_time, compare_stop_time]
    flag = filterDateRange(baseTimeRange,compareTimeRange)
    if(flag){
        $(this).attr("flag") == "1" ? 
          $("button[flag='0']").attr("class","btn lost_btn btn-default") : $("button[flag='1']").attr("class","btn lost_btn btn-default")
        $(this).attr("class","btn lost_btn btn-info")
        var current_table = {"0": "base_lost_report_list", "1": "compare_lost_report_list"};
        var flag = $(this).attr("flag");
        model = getModel();
        model.tb_id = current_table[flag];
        model.attributes["columnDefs"][0]["targets"] = getHiddenCols();
        model.params["seed_lost_report"]["compare_flag"] = flag;
        $("table").hide();
        $("#" + model.tb_id).show();
        refreshTable(_.values(current_table));
        $("th[tag='group_field']").each(function(){
           $(this).text(group_mappings[$("#group_field").val()][0])
        })
        $("th[tag='group_field1']").each(function(){
           $(this).text(group_mappings[$("#group_field").val()][1])
        })
        $("th[tag='base_event_num'],th[tag='base_event_num2']").each(function(){
          event_arr = event_mappings[$("#event_process").val()]
          $(this).text(event_arr[0])
        })
        $("th[tag='compare_event_num'],th[tag='compare_event_num2']").each(function(){
          event_arr = event_mappings[$("#event_process").val()]
          $(this).text(event_arr[1])
        })
        new DeviceListView(model);
    }
});


function filterDateRange(baseTimeRange,compareTimeRange){
    baseFlag = filter(baseTimeRange)
    compareFlag = filter(compareTimeRange)
    if(baseFlag == 1){
      $(".alert").html("基准时间段日期选择有误!").attr("class","alert alert-error").show().delay(3000).fadeOut()
      return false
    }
    if(compareFlag == 1){
      $(".alert").html("对比时间段日期选择有误!").attr("class","alert alert-error").show().delay(3000).fadeOut()
      return false
    }
    return true
}

function filter(timeRange){
    today = new Date()
    count = 0
    startDate = new Date(timeRange[0])
    endDate = new Date(timeRange[1])
    if(startDate.getTime() - endDate.getTime() > 0 || startDate.getTime() > today.getTime())
      return 1;
    for(i = 0; i < timeRange.length; i++){
        dateStr = timeRange[i]
        var date = new Date(dateStr)
        var year = date.getFullYear()
        var month = date.getMonth()+1
        var day = date.getDate()
        if(year == today.getFullYear() && month == (today.getMonth()+1) && day == today.getDate()){
            count += 1
        }
    }
    return count;
}
