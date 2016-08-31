
//监听省份select的change事件，动态生成城市列表
function listenerSelect(cache_cities,options,show){
  $("select[name = 'province_id' ]").on("change",function(ele){
    $("select[name = 'city_id' ]").html('');
    $("select[name = 'city_id' ]").append($('<option>', {value: '', text: '请选择'}));
    var province_id = $(this).val();
    if(options){
      keys = _.keys(options);
      values = _.values(options);
      _.each(keys,function(k,index){
        if(province_id!=null) $("select[name = 'city_id' ]").append($('<option>', {value: values[index], text: k}));
      })
    }
    

    _.each(cache_cities,function(item){
      option =  '<option parent-id="'+$(item).attr("parent-id")+'" value="'+$(item).val()+'">' + $(item).text()+'</option>';
      if($(item).attr("parent-id") == province_id ){
        $("select[name = 'city_id' ]").append(option);
      }
      if((province_id=="all" || province_id == "0") && show ) {
        if($(item).val() != "0" && $(item).val() != "all" && province_id != "") $("select[name = 'city_id' ]").append(option);
      }
        
    })
    $("select[name = 'city_id' ]").trigger("change");
  });
}