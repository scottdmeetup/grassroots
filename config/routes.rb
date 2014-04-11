Grassroots::Application.routes.draw do
  root to: 'pages#home' 

  resources :users, only: [:show]
  resources :organizations, only: [:show]
end
