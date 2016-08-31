function getModel(){
    var ItemModel =
    {
        tb_id: "solution_report_list",
       
        set_class: function(el,item){
            if(item.attributes.plan_id == "") item.attributes.plan_id = "0";
            item.attributes.plan_id == "0" ? $(el).addClass("info") : "";
            if(item.attributes.plan_id == "0"){
                $(el).addClass("info");
                $($(el).children()[$("#solution_report_list th[tag='plan_id']").index()]).html("汇总");
            }else{
                return false;
            }
        }
    }

    return ItemModel;
}

getPageView(getModel());