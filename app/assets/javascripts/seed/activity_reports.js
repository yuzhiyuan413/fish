
function getModel(){
  var ItemModel =
    {
      tb_id: "activity_report_list",
      set_class: function(el,item){
          return false;
      }
    }
    return ItemModel;
}

getPageView(getModel());