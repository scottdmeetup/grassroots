Grassroots::Application.routes.draw do
  root to: 'pages#home' 
  get 'sign_in', to: 'sessions#new'
  post 'log_in', to: 'sessions#create'
  get 'log_out', to: 'sessions#destroy'

  resources :users, only: [:show, :new, :create]
  resources :organizations, only: [:show]
  resources :projects, only: [:index, :show]
end
