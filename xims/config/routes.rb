Xims::Application.routes.draw do
  devise_for :users, :skip => [:registrations], :controllers => { :sessions => "sessions" }
  devise_scope :user do
    get 'users/current_user' => 'sessions#show_current_user', :as => 'show_current_user'
  end
  get '/:organization_id/employees', to: 'employees#index', constraints: {organization_id: /\d+/}
  get '/employees/:employee_id', to: 'employees#show', constraints: {employee_id: /\d+/}
  put '/employees/:employee_id', to: 'employees#update', constraints: {employee_id: /\d+/}

  get '/:organization_id/trainings', to: 'trainings#index', constraints: {organization_id: /\d+/}
  post '/:organization_id/trainings', to: 'trainings#create', constraints: {organization_id: /\d+/}

  get '/:organization_id/employees/alerts/:alert_type/', to: 'alerts#employees', constraints: {organization_id: /\d+/, alert_type: /\d+/}

  get '/trainings/:training_id', to: 'trainings#show', constraints: {training_id: /\d+/}
  get '/trainings/:training_id/employees', to: 'training_employees#index_employees', constraints: {training_id: /\d+/}
  get '/trainings/:employee_id/trainings', to: 'training_employees#index_trainings', constraints: {employee_id: /\d+/}

  get '/search/employees', to: 'search#employees'

  post '/uploads/', to: 'uploads#create'
  get '/uploads/', to: 'uploads#index'
  get '/uploads/:upload_id', to: 'uploads#show', constraints: {upload_id: /\d+/}

  get '/data-importer/:upload_id', to: 'data_importer#show', constraints: {upload_id: /\d+/}
  post '/data-importer/:upload_id', to: 'data_importer#create', constraints: {upload_id: /\d+/}

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
end
