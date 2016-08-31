function getModel(){
  var ItemModel = 
      {
        tb_id: "arrival_report_list",
        url: "/seed/arrival_reports/index",
        
        set_class: function(el,item){
            return false;
        }
      }

  return ItemModel;
}
    
 
getPageView(getModel());