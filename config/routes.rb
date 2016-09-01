Rails.application.routes.draw do

  root :to => 'system/login#index'
  get 'heartbeat' => 'system/login#heartbeat'
  mount API, at: 'api'
  namespace :system do
    resources :accounts
    resources :roles
    resources :tag_groups
    get 'permissions/get_functions' => 'permissions#get_functions'
    resources :permissions do
      collection do
        get 'sort'
      end
    end
    resources :permissions
    resources :logs do
      collection do
        get 'index'
        get 'dir'
        get 'log_file'
        get 'down_log'

      end
    end

  end

  namespace :generator do
    resources :generators_operate do
      collection do
        post 'create'
        get 'files_name'
        get 'read_file/:file_name' => 'generators_operate#read_file'
        delete 'delete_file/:file_name' => 'generators_operate#delete_file'
      end
    end
    resources :generators_operate
  end

  namespace 'charge' do
    match 'monthly_code_alive_reports/:id/edit', to: 'monthly_code_alive_reports#edit', via: [:get]
    match 'monthly_code_alive_reports/:id', to: 'monthly_code_alive_reports#update', via: [:post, :put, :patch]
  end

  match '/:controller/:action', via: [:get, :post]
  get 'charge/sms_cats' => 'charge/sms_cats#index'
  #match '/:controller/:action/:id'
  #match '/:controller/:action/:id.:format'
  #match '/:controller.:format', via: [:get, :post]
  #match '/:controller/:action.:format', via: [:get, :post]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
