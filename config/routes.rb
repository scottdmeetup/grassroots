Grassroots::Application.routes.draw do
  root to: 'pages#home' 
  get 'sign_in', to: 'sessions#new'
  post 'log_in', to: 'sessions#create'
  get 'log_out', to: 'sessions#destroy'

  mount Attachinary::Engine => "/attachinary"

  namespace :organization_admin do
    resources :projects, only: [:new, :create, :edit, :update]
    resources :organizations, only: [:edit, :update, :new, :create]
    resources :volunteer_applications, only: [:index]
  end

  namespace :volunteer do
    resources :volunteer_applications, only: [:index]
  end

  resources :users, except: [:destroy] do
    collection do
      get 'search', to: 'users#search', as: 'search'
    end
  end
  delete 'remove', to: 'users#remove'
  
  resources :organizations, only: [:show, :index] do
    collection do
      get 'search', to: 'organizations#search', as: 'search'
    end
  end
  
  resources :projects, only: [:index, :show] do
    collection do
      get 'search', to: 'projects#search', as: 'search'
    end
  end
  get 'join', to: 'projects#join', as: 'join'

  resources :private_messages, only: [:new, :create] 
  resources :volunteer_applications, only: [:new, :create]
  resources :contracts, only: [:create, :new, :destroy, :update]
  resources :work_submissions, only: [:new, :create]
  resources :conversations, only: [:show, :index]

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :questions, only: [:index, :show, :new, :create, :edit] do
    #post 'comments', to: 'comments#create'
    resources :comments, only: [:create]
    resources :answers, only: [:create] do
      resources :comments, only: [:create]
      #post 'comments', to: 'comments#create'
    end
  end
end
