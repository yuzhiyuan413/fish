// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
// dataTables
//= require dataTables/datatables.min
// backbone
//= require backbone/underscore
//= require backbone/backbone
// page loading
//= require fakeloader.min.js
//= require fastclick.min
//= require jquery.slimscroll.min
//= require moment
//= require moment/zh-cn
//= require bootstrap-datetimepicker
//= require select2
//= require city-select
//codemirror
//= require codemirror/codemirror
//= require codemirror/ruby
//= require codemirror/sublime
// table view
//= require tablebase
// form view
//= require formbase

// Init JS Component


$(document).on("page:change",function() {
    window.FakeLoader.init();
    $(window).scroll(function() {
        if ($(window).scrollTop() > $(window).height()){
            $('div.go-top').fadeIn(300);
        }else{
            $('div.go-top').fadeOut(100);
        }
    });
    $('div.go-top').click(function() {
        $('html, body').animate({scrollTop: 0}, 250);
    });
});
function init_select(attributes){
    var default_attrs = {
        theme: "bootstrap",
        placeholder: "请选择"
    }
    var init_attrs = $.extend(default_attrs, attributes || {});
    $(".select2").select2(init_attrs);
}

function table_btn_to_ch(buttons){
    maps = {"copy":"复制","excel":"Excel","print":"打印","colvis":"列显示/隐藏"};
    _.each(buttons,function(item){
        $(".buttons-" +item +" span").html(maps[item]);
    });
}


function init_dataTables(tb_id, attributes){
    var default_attrs = {
        language: {
            "emptyTable":     "无数据",
            "info":           "共 _TOTAL_ 项",
            "infoEmpty":      "共 0 项",
            "infoFiltered":   "（从 _MAX_ 项结果中过滤）",
            "lengthMenu":     "显示 _MENU_ 项结果",
            "loadingRecords": "载入中...",
            "processing":     "处理中...",
            "search":         "全文搜索：",
            "zeroRecords":    "没有匹配的结果"
        },
        buttons:        ['copy', 'excel', 'print', 'colvis'],
        scrollY:        "",
        scrollX:        true,
        scrollCollapse: true,
        stateSave:      true,//保存最后的操作状态
        paging:         false,
        fixedColumns:   false,
        destroy: true
         
    }
    var init_attrs = $.extend({}, default_attrs, attributes);
    var dt = $('#'+tb_id).DataTable(init_attrs);
    
    dt.buttons().container().appendTo( '#'+tb_id+'_wrapper .col-sm-6:eq(0)' );
    table_btn_to_ch(init_attrs.buttons);
    
    defaultOrder = (attributes && attributes["order"]) ? attributes["order"] : [[0,'asc']]
    $('#'+tb_id).on( 'stateSaveParams.dt', function (e, settings, data) {
         data.search.search = "";
         data.order = defaultOrder;
    } );
 }


function postSend(purl, pdata,callback, pdatatype, ptype) {
    $.ajax({
      url: purl,
      type: ptype,
      data: pdata,
      dataType: pdatatype,
      // beforeSend:function(){
      //   window.FakeLoader.showOverlay();
      // },
      success: callback,
      error: function (e) {
      }
    });
  }

/**
 * 数字格式转换成千分位
 *@param{Object}num
 */

function delimiter(num){
    if((num+"").trim()==""){
        return "";
    }
    if(isNaN(num)){
        return "";
    }
    if(num) num = parseFloat(num).toFixed(2);
    num = num+"";
    if(/^.*\..*$/.test(num)){
        var pointIndex =num.lastIndexOf(".");
        var intPart = num.substring(0,pointIndex);
        var pointPart =num.substring(pointIndex+1,num.length);
        intPart = intPart +"";
        var re =/(-?\d+)(\d{3})/
        while(re.test(intPart)){
            intPart =intPart.replace(re,"$1,$2")
        }
        num = intPart+"."+pointPart;
    }else{
        num = num +"";
        var re =/(-?\d+)(\d{3})/
        while(re.test(num)){
            num =num.replace(re,"$1,$2")
        }
    }
    if(num == "null")
        num = "";
    return num.replace(".00","");
}


/**
 * 去除千分位
 *@param{Object}num
 */
function delcommafy(num){
    if((num+"").trim()==""){
        return"";
    }
    num=num.replace(/,/gi,'');
    return num;
}


/**
 *百分比,保留两位小数
 * @param{Object} num
 */
function percentage(num){
    if((num+"").trim()==""){
        return"";
    }
    if(isNaN(num)){
        return"";
    }
    num *= 100;
    num = parseFloat(num).toFixed(2);
    num += '%';
    if(num == "0.00%")
        num = ""
    return num;
}

function percent_int(num){
    if((num+"").trim()==""){
        return"";
    }
    if(isNaN(num)){
        return"";
    }
    num *= 100;
    num = Math.round(parseFloat(num).toFixed(2));
    num += '%';
    if(num == "0%")
        num = ""
    return num;
}


/**
 * 保留两位小数
 */
function precision(num){
    if((num+"").trim()==""){
        return "";
    }
    if(isNaN(num)){
        return "";
    }
    if(num == null){
        return parseFloat(0).toFixed(2);
    }
    num = parseFloat(num).toFixed(2);
    return num;
}

/**
 * 货币单位分转元
 * @param{Object} num
 */
function centToYuan(num){
    if((num+"").trim()==""){
        return"";
    }
    if(isNaN(num)){
        return"";
    }
    num /= 100;
    num = parseFloat(num);
    num = delimiter(num)
    return num;
}

function roundToInt(num){
    num = delcommafy(num)
    if(num.trim()==""){
        return "";
    }
    num = Math.round(parseFloat(num));
    num = delimiter(num)
    return num;
}

//自适应字体大小
function getFontSize(){
    radio = 0.0072 //比例尺
    fontSize = parseInt($(document).width() * radio)
    $(document.body).attr("style","font-size:"+fontSize+"px;")
}

//TD列设置ellipsis
function setEllipsis(){
    $("table tbody td").each(function(){
         tdText = $(this).text();
         tdWidth = $(this).width();
         radio = 0.15;
         diff = 0.00;
         var reg = new RegExp("[\\u4E00-\\u9FFF]+","g");
         if(reg.test(tdText)){
            specialLength = tdText.split('_').length
            currentLength = (specialLength > 2 ) ? tdText.length - (specialLength / 2).toFixed(0) : tdText.length
            diff = (currentLength * 2 / tdWidth).toFixed(2)
         }else{
             diff = (tdText.length / tdWidth).toFixed(2)
         }
         if (diff >= radio ){
            setTdStyle(this)
         }else{
            removeTdStyle(this)
         }
    });
}
//数据列附属样式设置
function setTdStyle(td){
   $(td).css({"overflow":"hidden","text-overflow":"ellipsis","white-space":"nowrap"}).attr({"title":tdText});
}
//数据列附属样式清除
function removeTdStyle(td){
    $(td).css({"overflow":"","text-overflow":"","white-space":""});
    $(td).removeAttr("title");
}

function refreshTable(ids){
    _.each(ids,function(id){
        $("#"+id).DataTable().destroy();
        $("#"+id+" tbody").html('');
    })
     
}

