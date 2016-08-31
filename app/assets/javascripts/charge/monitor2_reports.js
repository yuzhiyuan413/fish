
function getModel()
{
    var model = {
        tb_id: "daily_report2_list",
        attributes: {
          order: [[ 2, "desc" ]],
          scrollY: "",
          scrollX: false
        },
        url:'/charge/monitor2_reports/index',
        params:{
            "charge_monitor2_report":{
                report_hour:$("#report_hour").val(),
                code_number:$("#code_number").val(),
                province_id:$("#province_id").val(),
                operator_id:$("#operator_id").val(),
                dest_number:$("#dest_number").val(),
                host_fullname:$("#host_fullname").val(),
                city_id:$("#city_id").val(),
                sp_id:$("#sp_id").val()

            }
        },
        overflow_hidden: "x",
        set_class: function(el,item){
            return false;
        },
        other_model:{
            tb_id: "hour_report2_list",
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

new DeviceListView(getModel());


$("#monitor_btn").on("click",function(){
    refreshTable(['daily_report2_list','hour_report2_list'])
    new DeviceListView(getModel())
});

$options_city = $("select[name = 'city_id_hidden'] option");
listenerSelect($options_city,{},false);
