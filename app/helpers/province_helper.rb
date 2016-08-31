# -*- encoding : utf-8 -*-
module ProvinceHelper
  PROVINCE_MAP = {"全部省份"=>"全部省份",-1=>"其他省份",1=>"北京",2=>"天津",3=>"上海",
    4=>"重庆",5=>"河南",6=>"河北",7=>"山西",8=>"内蒙古",9=>"辽宁",10=>"吉林",
    11=>"黑龙江",12=>"江苏",13=>"浙江",14=>"安徽",15=>"福建",16=>"江西",17=>"山东",
    18=>"湖北",19=>"湖南",20=>"广东",21=>"广西",22=>"海南",23=>"四川",24=>"贵州",
    25=>"云南",26=>"西藏",27=>"陕西",28=>"甘肃",29=>"青海",30=>"宁夏",31=>"新疆",
    32=>"香港",33=>"澳门",34=>"台湾",35=>"国外"}

  def province_id_to_name id
    PROVINCE_MAP[id]
  end

  def records_province_id_to_name records
    {}.tap do |x|
      records.each do |k,v|
        k[:province] = province_id_to_name(k[:province])
        x[k] = v
      end
    end
  end

end
