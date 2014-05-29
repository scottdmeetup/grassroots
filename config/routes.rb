Grassroots::Application.routes.draw do
  root to: 'pages#home' 
  get 'sign_in', to: 'sessions#new'
  post 'log_in', to: 'sessions#create'
  get 'log_out', to: 'sessions#destroy'

  namespace :organization_admin do
    resources :projects, only: [:new, :create, :edit, :update]
    resources :organizations, only: [:edit, :update]
    resources :volunteer_applications, only: [:index]
  end

  namespace :volunteer do
    resources :volunteer_applications, only: [:index]
  end

  resources :users, except: [:destroy]
  delete 'remove', to: 'users#remove'
  resources :organizations, only: [:show, :index, :new, :create]
  resources :projects, only: [:index, :show, :edit] do
    collection do
      get 'search', to: 'projects#search', as: 'search'
    end
  end
  get 'join', to: 'projects#join', as: 'join'

  resources :private_messages, only: [:new, :create] 
  get 'outgoing_messages', to: 'private_messages#outgoing_messages', as: 'outgoing_messages'
  resources :volunteer_applications, only: [:index]
  
  resources :contracts, only: [:create]

  resources :conversations, only: [:show, :index]
  get 'accept', to: 'conversations#accept'
  get 'request_complete', to: 'conversations#request_complete'
  get 'confirm_complete', to: 'conversations#confirm_complete'
  get 'drop', to: 'conversations#drop'
end
