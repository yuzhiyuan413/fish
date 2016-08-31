# -*- encoding : utf-8 -*-
module AliveReportsHelper
	def stay_alive_ratio stay_alive_num, activation_num
		if stay_alive_num
			number_to_percentage((stay_alive_num.to_f/activation_num.to_f) * 100, :precision => 2)
		else
			""
		end
	end

	def colorGrad activation_num, stay_alive_num
		return "" if stay_alive_num.nil?
		ratio = (format("%.2f",stay_alive_num.to_f/activation_num.to_f).to_f * 100).to_i
		grid_color ratio
	end

	def grid_color idx
		r = (-2 * idx) + 182
		g = (-1 * idx) + 242
		b = (-1 * idx) + 243
		"rgb(#{r},#{g},#{b})"
  end
end
