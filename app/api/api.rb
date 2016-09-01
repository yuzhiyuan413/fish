class API < Grape::API
	version 'v1', using: :path
	format :json
	rescue_from :all
	error_formatter :json, lambda do |message, backtrace, optioins, env|
		{
			status: 'failed',
			message: message,
			error_code: 123
		}
	end
  mount Seed::SeedAPI
end