function getModel()
{
    var model = {
        tb_id: "conversion_reports_list",
        set_class: function(el,item){
            return false;
        }
    }
    return model;
}


getPageView(getModel());