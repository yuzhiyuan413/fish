function getModel(){
  var ItemModel = 
      {
        tb_id: "prop_report_list",
       
        set_class: function(el,item){
          item.attributes.manufacturer == "厂商汇总" ? $(el).addClass("info") : "";
        }
      }

    return ItemModel;
  }
 
getPageView(getModel());