init_select({allowClear: true});
function getModel()
{
    var model = {
        tb_id: "daily_report_list",
        attributes: {
          order: [[ 3, "desc" ]],
          scrollY: "",
          buttons:['copy', 'excel', 'print'],
          columnDefs: [{
            targets: [0],
            visible: false
          }],
          stateSave: false,
          scrollX: false
        },
        url:'/charge/monitor_reports/index',
        show_url: '/charge/monitor_reports/show_list_ajax',
        params:{
            "charge_monitor_report":{
                report_hour:$("#report_hour").val(),
                code_number:$("#code_number").val(),
                province_id:$("#province_id").val(),
                operator_id:$("#operator_id").val(),
                dest_number:$("#dest_number").val(),
                city_id:$("#city_id").val(),
                sp_id:$("#sp_id").val()

            }
        },
        overflow_hidden: "x",
        set_class: function(el,item){
            return false;
        },
        other_model:{
            tb_id: "hour_report_list",
            attributes: {
              scrollY: "910px",
              scrollX: false
            },
            set_class: function(el,item){
                return false;
            }
        }
    }
    return model;
}
function getHiddenCols(){
    if($("#province_id").val() == "0" || $("#city_id").val() == "0") {
      return [1,2];
    }
    else{
      return[0];
    }
}

new DeviceListView(getModel());
$("tbody").delegate("span.show-list","click",function(){ 
    model = getModel();
    var params = {hour_num:$(this).attr("hour-num"),
                  data_tag:$(this).attr("data-tag")};
}); 

$("#monitor_btn").on("click",function(){
    refreshTable(['daily_report_list','hour_report_list'])
    model = getModel();
    hidden_col = getHiddenCols();
    model.attributes["columnDefs"][0]["targets"] = hidden_col;
    new DeviceListView(model)
});

$options_city = $("select[name = 'city_id_hidden'] option");
listenerSelect($options_city,{"全部城市":"0"},false);
