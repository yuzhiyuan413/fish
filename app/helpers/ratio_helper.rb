# -*- encoding : utf-8 -*-
module RatioHelper

  def divider dividend, divisor
    return nil if dividend.blank? or divisor.blank?
    return 0 if dividend.zero? or divisor.zero?
    number_with_precision((dividend/divisor.to_f) * 100, :precision => 2)
  end

  def strfratio ratio
    number_to_percentage(ratio, :precision => 2)
  end

  def gradient_color ratio
    return "" if ratio.blank?
    generate_gradient_color ratio.to_i
  end

  def generate_gradient_color idx
    r = (-2 * idx) + 182
    g = (-1 * idx) + 242
    b = (-1 * idx) + 243
    "rgb(#{r},#{g},#{b})"
  end

  def ratio dividend, divisor
    return 0 if divisor.nil? or dividend.nil? or divisor.zero? or dividend.zero?
    dividend.to_f/divisor.to_f
  end
end
