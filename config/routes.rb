Grassroots::Application.routes.draw do
  root to: 'pages#home' 
  get 'sign_in', to: 'sessions#new'
  post 'log_in', to: 'sessions#create'
  get 'log_out', to: 'sessions#destroy'

  namespace :organization_admin do
    resources :projects, only: [:new, :create]
  end

  resources :users, only: [:show, :new, :create, :index]
  resources :organizations, only: [:show]
  resources :projects, only: [:index, :show]
  get 'join', to: 'projects#join', as: 'join'
  get 'search', to: 'projects#search', as: 'search'

  resources :private_messages, only: [:new, :create]
  get 'outgoing_messages', to: 'private_messages#outgoing_messages', as: 'outgoing_messages'

  resources :conversations, only: [:show, :index]
  get 'accept', to: 'conversations#accept'
  get 'completed', to: 'conversations#completed'
  get 'drop', to: 'conversations#drop'
end
