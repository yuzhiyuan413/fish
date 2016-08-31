module Charge::SmsCatsHelper
  def get_percentage_result(receive_num, register_num)
    if register_num.to_i == 0 || receive_num.to_i == 0
      return "0.0%"
    end
    result = (receive_num/register_num.to_f) * 100
    number_to_percentage(result, precision: 2)
  end

  def get_sms_cat_nums(data, sms_cat_number, hour)
    hour_data = data[sms_cat_number]
    return [0, 0] if hour_data.blank?

    num_data = hour_data[hour]
    return [0, 0] if num_data.blank?

    [num_data[:receive_num].to_i, num_data[:register_num].to_i]
  end

end
