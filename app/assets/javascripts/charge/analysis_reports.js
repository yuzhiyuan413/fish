init_select();

function getModel()
{
    var model = {
        tb_id: "analysis_report_list",
        attributes: {
          scrollY: "",
          scrollX: false,
          columnDefs: [{
            targets: [9,13],
            visible: false
          }],
        },
        url:'/charge/analysis_reports/index',
        params:{
            "charge_analysis_report":{
                start_date:$("#start_date").val(),
                end_date:$("#end_date").val(),
                current_tag:$("#current_tag").val(),
                code_number:$("#code_number").val(),
                dest_number:$("#dest_number").val(),
                province_id:$("#province_id").val(),
                city_id:$("#city_id").val(),
                operator_id:$("#operator_id").val(),
                sp_company:$("#sp_company").val(),
                sp_id:$("#sp_id").val(),
                business_coding:$("#business_coding").val(),
                unit:$("#unit").val(),
                code_union_name_flag:$("#code_union_name_flag").is(":checked"),
                report_date_flag:$("#report_date_flag").is(":checked")

            }
        },
        set_ellipsis: true,
        overflow_hidden: "x",
        set_class: function(el,item){
            return false;
        }

    }
    return model;
}

new DeviceListView(getModel());

$("#analysis_btn").on("click",function(){
    refreshTable(['analysis_report_list'])
    new DeviceListView(getModel())

});

$options_city = $("select[name = 'city_id_hidden'] option")


$("select[name = 'unit' ]").on("change",function(ele){
  unit = $(this).find("option:selected").attr("unit");
  $(".unit").attr("field_exec",unit);
})
select_ids = ["province_id","city_id","operator_id","sp_id","current_tag","business_coding"];
ids = ["code_union_name_flag","report_date_flag"];
listenerSelect($options_city,{"全部城市":"all","城市明细":"0"},true);

$("input[type='checkbox'").click(function(){
   me = $(this);
   if(me.is(":checked")){
        _.each(ids,function(id){
            if(id != me.attr("id")) $("input[name='"+id+"']").attr("checked",false);
        });
        _.each(select_ids,function(s_id){
            if($("#"+s_id).val() == "0") $("#"+s_id).val('all').trigger("change");
        })
    }
})

$('.select2').on('select2:select', function (evt) {
  selectVal = evt.target.value;
  eleId = evt.target.id;
  if(selectVal == 0){
    _.each(select_ids,function(s_id){
        if(s_id != eleId && $("#"+s_id).val() == "0") $("#"+s_id).val('all').trigger("change");
    })
    _.each(ids,function(id){
        if($("#"+id).is(":checked")) $("#"+id).attr("checked",false);
    });
    if(eleId == "city_id") $("#"+eleId).val('0').trigger("change");
  }
});
