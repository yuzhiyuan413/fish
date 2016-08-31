function getModel(){
  var ItemModel = 
      {
        tb_id: "device_report_list",
        set_class: function(el,item){
          item.attributes.model == "型号汇总" ? $(el).addClass("info") : "";
        }
      }
    return ItemModel;
 } 
 
getPageView(getModel());