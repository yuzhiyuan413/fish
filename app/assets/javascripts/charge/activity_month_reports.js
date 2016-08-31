function getModel()
{
    var model = {
        tb_id: "charge_month_report_list",
        set_class: function(el,item){
            return false;
        }
    }
    return model;
}


getPageView(getModel());