module Seed
	class SeedAPI < API

		resource :seed do 
			get :index do 
				{hello: 'good'}
			end
		end

	end
end