
var FormView = Backbone.View.extend({
    initialize: function (obj) {
        templeteForm(obj);
        initForm();
    }
});


function getFormParams(formModel){
    var param = {};
    _.each(formModel.form_items, function (item) {
        param[item.name] = $("#"+formModel.name+"_"+item.name).val();
    })
    return param;
}
//生成form 和 table 的视图

function getPageView(itemModel){
    var form_name = $("#view_form").attr("form-name");
    postSend($("#view_form").attr("url"),"",function(data){
        new FormView(data.form);
        if(itemModel != null){
            itemModel["url"] = data.form.action;
            var tmp_param = {};
            tmp_param[form_name] = getFormParams(data.form)
            itemModel["params"] = tmp_param;
            new DeviceListView(itemModel);
        }
        specialProcess(form_name);
    }, "json", "get");
}

function render_select_group(list,default_value){
    var results = "";
    var option_group = "";
    if(list){
        if(list[0] instanceof Array && list[0][list[0].length-1] instanceof Array ){
            _.each(list,function(group,index){
                _.each(group,function(item,index){
                    if(index==0) {
                        option_group += "<optgroup label='"+item+"'>";
                    }else{
                        option_group += render_select(item,default_value)
                    }
                })
                option_group += "</optgroup>";
            })
            results += option_group;
        }else{
            results = render_select(list,default_value);
        }
    }

    return results;
}

function render_select(list,default_value){
    option = "";
    _.each(list,function(item){
        val = text ="";
        if(item instanceof Array){
            text = item[0];
            val = item[1];
        }else{
            text = val = item;
        }
        if(text == default_value)
            option += "<option selected value='"+val+"'>"+text+"</option>";
        else
            option += "<option  value='"+val+"'>"+text+"</option>";
    });
    return option;
}
// form
function templeteForm(obj){
    $("#view_form").attr("name",obj.name);
    $("#view_form").attr("action",obj.action)
    _.each(obj.form_items, function (item) {
        eleName = item.name;
        eleType = item.attributes.input_type;
        eleData = item.attributes.data;
        default_data = item.attributes.default
        if(!$("#"+obj.name+"_"+item.name)[0]){
            ele = getTempleteElement(eleType, eleName);
            findType = eleType == "select" ? "select" : "input"
            $(ele).find(findType).attr("id",obj.name+"_"+item.name);
            $(ele).find(findType).attr("name",obj.name+"["+item.name+"]");
            if(eleType == "select"){
                $(ele).children().html(render_select_group(eleData,default_data));
            }else{
                $(ele).find(findType).attr("value",default_data);
            }
            $(ele).removeClass("hide");
            $("#view_form_div").append($(ele));
        }

    })
    if($("#form_btn_clone").length==0){
      $("#view_form_div").append($("#form_btn").clone().attr("id","form_btn_clone").removeClass("hide"));
        $("button[data-style]").on("click",function(){
            if($("#view_form").attr("form-name") == "charge_activity_trend_report"){
                $("#view_form").submit();
                return
            }
            if(getModel()){
                refreshTable([getModel().tb_id])
                getPageView(getModel());
            }else{
                refreshTable([getTableId1(),getTableId2()])
                getPageView1();
            }
        });
    }
}

// 根据input_type获取对应容器div
function getTempleteElement(eleType, eleName){
    eleId = ""
    if(eleType == "select")
        eleId = eleType + "_" + eleName

    else
        eleId = eleType
    return $("#"+eleId).clone();
}

//特殊报表处理
function specialProcess(formName){
    if( location.search != "" && formName == "charge_activity_trend_report"){
        startTime = location.search.substr(location.search.indexOf("from_date%5D=")+13,10)
        endTime = location.search.substr(location.search.indexOf("end_date%5D=")+12,10)
        $("#charge_activity_trend_report_form_from_date").val(startTime)
        $("#charge_activity_trend_report_form_end_date").val(endTime)
    }
}

//form内组件的加载
var initForm = function(){
    $('.monthpicker').datetimepicker({
        locale: 'zh-cn',
        viewMode: 'years',
        format: 'YYYY/MM'
    });
    $('.datepicker').datetimepicker({
        locale: 'zh-cn',
        viewMode: 'days',
        format: 'YYYY-MM-DD'
    });
    $('.hourpicker').datetimepicker({
        format: 'YYYY-MM-DD HH:mm'
    });

    $(".select2").select2({
        theme: "bootstrap",
        placeholder: "请选择"
        // allowClear: true
    });
}
