Grassroots::Application.routes.draw do
  root to: 'pages#home' 
  get 'sign_in', to: 'sessions#new'
  post 'log_in', to: 'sessions#create'
  get 'log_out', to: 'sessions#destroy'

  namespace :organization_admin do
    resources :projects, only: [:new, :create]
  end

  resources :users, only: [:show, :new, :create]
  resources :organizations, only: [:show]
  resources :projects, only: [:index, :show]
<<<<<<< HEAD
  get 'join', to: 'projects#join', as: 'join'

  resources :private_messages, only: [:new, :create, :index]

=======
  get 'request_join', to: 'projects#request_join', as: 'request_join'
>>>>>>> 433a5fc... sets up the start of writing out specs for a private messaging system
end
