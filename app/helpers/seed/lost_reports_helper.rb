module Seed::LostReportsHelper
	def solution_plan_options
		options_for_select(SwordDs::SeedFeedbackHistory.plan_options)
	end

	def lost_report_tag_options
		options_for_select(SmartDs::ProductTag.seed_lost_options)
	end

end
