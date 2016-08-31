class Date
	def all_day
		self.beginning_of_day..self.end_of_day
	end
end

class Array
	def median
	  sorted = self.sort
	  len = sorted.length
	  return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
	end
end
