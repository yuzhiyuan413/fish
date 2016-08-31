function getModel()
{
    var model = {
        tb_id: "charge_alive_list",
        is_ratio:true,
        set_class: function(el,item){
            return false;
        }
    }
    return model;
}


getPageView(getModel());