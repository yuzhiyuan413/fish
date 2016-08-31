# -*- encoding : utf-8 -*-
class ModelMappings

  CHARGE_PARAMS_MODELS = {
    :charge_activation => "ChargeDs::ReportUser",
    :charge_activity => "ChargeDs::ReportRequestHistory",
    :charge_activity_month => "ChargeDs::ReportRequestHistory",
    :charge_alive => "ChargeDs::ReportUser"
  }

  CHARGE_REPORT_COLUMNS = {
    :charge_activation => {
      :extract_column => [:tag, :loader_version_short],
      :load_columns => [:tag, :product_version]
    },
    :charge_activity => {
      :extract_column => [:tag, :loader_version_short, :province_id],
      :load_columns => [:tag, :product_version, :province]
    },
    :charge_activity_month => {
      :extract_column => [:tag, :loader_version_short, :province_id],
      :load_columns => [:tag, :product_version, :province]
    },
    :charge_alive => {
      :extract_column => [:tag, :loader_version_short],
      :load_columns => [:tag, :product_version]
    }
  }

  CHARGE_COLUMN_MAPPING = {
    :tag => :tag,
    :loader_version_short => :product_version,
    :province_id => :province
  }

  CHARGE_SUM_PARAMS = {
    :tag => "全部标签",
    :loader_version_short => "全部版本",
    :province_id => "全部省份",
  }

  OPERATOR_ID_TO_ATTR_WRITE = {
    0 => "others_sp_num=",
    1 => "cmcc_num=",
    2 => "cucc_num=",
    3 => "ctcc_num="

  }

  OPERATOR_NAME_TO_ID = {
    "-其他-" => 0,
    "-移动-" => 1,
    "-联通-" => 2,
    "-电信-" => 3
  }

  OPERATOR_NAME_TO_COLUMN = {
    "-其他-" => "others_sp_num",
    "-移动-" => "cmcc_num",
    "-联通-" => "cucc_num",
    "-电信-" => "ctcc_num"
  }

  EVENT_TO_EVENT_ID = {
    :solution_executing => "solution_executing",
    :solution_executed => "solution_executed",
    :solution_canceled => "solutionCanceled",
    :solution_successed => "solution_executed",
    :solution_installed => "solution_executed",
    :v8_exists => "solution_executed",
    :v9_exists => "solution_executed"
  }

  EVENT_TO_SETTER_FUNC = {
    :solution_executing => "execting_count=",
    :solution_executed => "exected_count=",
    :solution_canceled => "canceled_count=",
    :solution_successed => "success_count=",
    :solution_installed => "installed_count=",
    :v8_exists => "v8_exists_count=",
    :v9_exists => "v9_exists_count="
  }

  EVENT_TO_CONDITIONS = {
    :solution_executing => nil,
    :solution_executed => nil,
    :solution_canceled => nil,
    :solution_successed => { :excuted_status => "Success" },
    :solution_installed => { :nut_code => [0,16,17]},
    :v8_exists => { :nut_code => [2]},
    :v9_exists => { :nut_code => [4]}
  }

  BOOL_TO_CN = { true => '是', false => '否'}

end
