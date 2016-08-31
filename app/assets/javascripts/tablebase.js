var DeviceModel = Backbone.Model.extend({
    defaults: {
        tag: "全部汇总"

    },
    render :function(attributes){
        var temp = "";
        if(this.attributes[attributes.tag + "_low_ratio"]){
            temp += "<td style='background:" + attributes.colors + "'>"
            temp += "<span>{{" + attributes.tag +" }}</span>"
            temp += "<span data-tag='"+attributes.tag+"' hour-num='"+this.attributes['hour_num']+"'  class = 'glyphicon glyphicon-arrow-down icon-small low-notice'>{{ percentage(" + attributes.tag +'_low_ratio'+") }}</span></td>";
        }else{
            temp += "<td class= '"+attributes.add_td_class+"' style='word-wrap:break-word;background:" + attributes.colors + ";color:"+attributes.td_color+"'>{{ " + attributes.tag + " }}</td>";
        }
        return temp;
    },

    add_ratio: function () {
        var me = this;
        _.each(["2","3","7","15","30"],function(item){
            current_ratio = parseFloat(me.attributes['ratio_alive'+item].replace('%',''))/100;
            me.attributes["background_alive"+item] = me.gradient_color(current_ratio);
        });

    },
    gradient_color: function (radio) {
        if (radio == "") {
            return "";
        } else {
            var r = (-2 * parseInt(radio * 100)) + 182;
            var g = (-1 * parseInt(radio * 100)) + 242;
            var b = (-1 * parseInt(radio * 100)) + 243;
            return "rgb(" + r + "," + g + "," + b + ")";
        }
    }
});

var DeviceList = Backbone.Collection.extend({
    Model: DeviceModel
});
var list = new DeviceList;
var footList = new DeviceList;
var DeviceItemView = Backbone.View.extend({
    tagName: "tr",
    initialize: function () {
        this.template = _.template(template(this.model));
    },

    render: function () {
        this.$el.html(this.template(this.model.attributes));
        return this;
    },
    events: {
      "click .td_click_field"   : "set_input_val"
    },
    set_input_val : function(){
        arr = []
        key = this.model.attributes.input_events.attr("tag");
        ids = this.model.attributes.input_events.attr("input_events").split('|');
        value = this.model.attributes[key];
        index = value.lastIndexOf('_');
        arr.push(value.substring(0,index))
        arr.push(value.substring(index+1));
        _.each(ids,function(item,index){
            if(ids.length == 1){
                $("#"+item).val(value);
                return false;
            }
            $("#"+item).val(arr[index]);
        })
    }
});


var DeviceListView = Backbone.View.extend({
    initialize: function (obj) {
        var me = this;
        window.FakeLoader.showOverlay();

        postSend(obj.url, obj.params,function (data) {
            if (data.foot) {
                me.load_foot_data(data.foot,obj);
            }

            if (data.other_foot) {
                me.load_foot_data(data.other_foot,obj.other_model);
            }

            if (data.body) {
                me.load_body_data(data.body,obj);
            }
            if (data.hourly_comparison){
                _.each(data.hourly_comparison,function(item,index){
                    if(item){
                        _.each(item,function(value,key){
                            data.other_body[index][key+"_low_ratio"] = value;
                        })
                    }
                })
            }

            if (data.other_body) {
                me.load_body_data(data.other_body,obj.other_model);
            }
            window.FakeLoader.hideOverlay();
            if (obj.overflow_hidden)
                setOverflowHidden(obj.overflow_hidden)
            $("tfoot td").css({"word-wrap":"break-word"});
            if(obj.set_ellipsis)
                setEllipsis()

        }, "json", "get");
    },
    load_body_data : function(data,model){

        var me = this;
        if (data.length == 0)  $("#" + model.tb_id + " tfoot").hide();
        loadData(data,model);
        //list.each(me.add_one);
        _.each(list.models, function (item, index) {
            me.add_one(item, model)
        });
        init_dataTables(model.tb_id, model.attributes);
        // if(!$("[data-layout='sidebar-collapse']").is(":checked"))
        //     $("[data-layout='sidebar-collapse']").click();
        // setTimeout(function(){
        //     init_dataTables(model.tb_id, model.attributes);
        // },500);
    },
    load_foot_data : function(data,model){
        var me = this;
        $("#" + model.tb_id + " tfoot").show();
        _.each(data, function (singleFoot, index) {
            if (singleFoot) {
                footData = singleFoot.table ? singleFoot.table : singleFoot;  //OpenStruct result包含table属性
                _.each(footData, function (item, key) {
                        me.add_foot(item, key, model, index);
                })
            }
        })
    },
    add_one: function (item, obj) {
        var itemView = new DeviceItemView({model: item.set({"tb_id": obj.tb_id})});
        var el = itemView.render().el;
        obj.set_class(el, item);
        $("#" + obj.tb_id + " tbody").append(el);
    },
    add_foot: function (item, key, obj, index) {
        _.each($("#" + obj.tb_id + " tfoot tr[index='" + index + "'] td[tag='" + key + "']"), function (ele) {
            $(ele).attr("type","foot");
            tmp_obj = {}
            tmp_obj[key] = item;
            data_transfer(tmp_obj,ele);
        })
    }
});

//生成数据模板

function template(model) {
    var tb_id = model.attributes.tb_id;
    thIndex = $("#" + tb_id).attr("th-index") ? $("#" + tb_id).attr("th-index") : 0;
    var temp = "";
    _.each($("#" + tb_id + " thead").find("tr").eq(thIndex).find("th"), function (ele, index) {
        tagAttr = {}
        tagAttr.tag = $(ele).attr("tag")
        if($(ele).attr("color") == model.attributes.color) {
          tagAttr.td_color =  model.attributes.color;
        }
        if($(ele).attr("input_events")){
          tagAttr.add_td_class = 'td_click_field';
          model.attributes.input_events = $(ele)
        }
        tagAttr = add_td_backgroud(tagAttr, model.attributes);
        temp += model.render(tagAttr);
    });
    return temp;
}

function add_td_backgroud(tagAttr, model) {
    var tag = tagAttr.tag.replace("stay_", "").replace("ratio_", "");
    _.each(["2", "3", "7", "15", "30"], function (item) {
        if (("alive" + item) == tag) {
            tagAttr.colors = model["background_alive" + item];
        }
    });
    return tagAttr;
}


function data_transfer(item,ele){
    var method_group = '';
    tag = $(ele).attr("tag");
    type = $(ele).attr("type");
    fieldExec = $(ele).attr("field_exec");
    if(fieldExec) method_group = fieldExec.split(',');
    color = $(ele).attr("color");
    if(color && item[tag] < 0.5) item.color = color;
    if (typeof(item) != "undefined" && item) {
        if(method_group) {
            _.each(method_group,function(func){
                tmp_function = func == "roundToInt" ? func+"('"+item[tag]+"')" : func+"("+item[tag]+")";
                item[tag] = eval(tmp_function)
                if(type == "foot") $(ele).html(item[tag]);
            })

        }
    }
}


//将服务端json数据add到Backbone集合中
function loadData(data,m) {
    list.reset();
    thIndex = $("#" + m["tb_id"]).attr("th-index") ? $("#" + m["tb_id"]).attr("th-index") : 0;
    _.each(data, function (item) {
        _.each($("#" + m["tb_id"] + " thead").find("tr").eq(thIndex).find("th"), function (ele, index) {
            $(ele).attr("type","body");
            data_transfer(item,ele);
        });
        var model = new DeviceModel(item);
        if(m.is_ratio) model.add_ratio();
        if(m.input_events) model.attributes.input_events = m.input_events;
        list.add(model);
    });
}
//隐藏table的滚动条
function setOverflowHidden(pos){
    overflowStr = "overflow-"+pos;
    obj = {}
    obj[overflowStr] = "hidden"
    $(".dataTables_scrollBody").css(obj);
}
