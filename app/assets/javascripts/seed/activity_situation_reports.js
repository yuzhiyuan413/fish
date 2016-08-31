function getModel(){
    return false;
}

function getPageView1(){
    postSend("/seed/activity_situation_reports/index","",function(data){
        new FormView(data.form);
        var itemModel =
        {
            tb_id: getTableId1(),
            url: data.form.action,
            attributes: {
              buttons: [],
              searching: false,
              ordering: false
            },
            params:{
                "seed_activity_situation_report":getFormParams(data.form),
                name:"activity_situation"
            },
            overflow_hidden: "x",
            set_class: function(el,item){
                return false;
            },
            other_model:{
                tb_id: getTableId2(),
                attributes: {
                  buttons: [],
                  searching: false,
                  ordering: false
                },
                set_class: function(el,item){
                  return false;
                }
            }
        }
        new DeviceListView(itemModel);
    }, "json", "get");
}


function getTableId1(){
    return "activity_situation_list";
}

function getTableId2(){
    return "activity_situation_detail_list";
}



getPageView1();
//getPageView2();
