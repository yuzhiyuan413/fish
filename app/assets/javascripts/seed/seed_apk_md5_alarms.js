
function getModel(){
  var ItemModel =
    {
      tb_id: "seed_apk_list",
      set_class: function(el,item){
         return false;
      }
    }

    return ItemModel;
}

getPageView(getModel());