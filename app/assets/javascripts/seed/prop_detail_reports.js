function getModel(){
  var ItemModel = 
      {
        tb_id: "prop_detail_report_list",
        set_class: function(el,item){
          item.attributes.board == "型号汇总" ? $(el).addClass("info") : "";
        }
      }
  return ItemModel;
}
getPageView(getModel());