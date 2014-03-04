Xims::Application.routes.draw do
  devise_for :users, :skip => [:registrations], :controllers => { :sessions => "sessions" }
  devise_scope :user do
    get 'users/current_user' => 'sessions#show_current_user', :as => 'show_current_user'
  end
  get '/:organization_id/employees', to: 'employees#index', constraints: {organization_id: /\d+/}
  get '/employees/:employee_id', to: 'employees#show'

  get '/:organization_id/trainings', to: 'trainings#index'
  post '/:organization_id/trainings', to: 'trainings#create'

  get '/:organization_id/employees/alerts', to: 'alerts#employees'

  get '/trainings/:training_id', to: 'trainings#show'
  get '/trainings/:training_id/employees', to: 'training_employees#index_employees'
  get '/trainings/:employee_id/trainings', to: 'training_employees#index_trainings'

  get '/search/employees', to: 'search#employees'

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
