
function getModel(){
  var ItemModel =
    {
      tb_id: "alive_report_list",
      is_ratio:true,
      set_class: function(el,item){
         return false;
      }
    }

    return ItemModel;
}

getPageView(getModel());