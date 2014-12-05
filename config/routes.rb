Rails.application.routes.draw do
  
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'sign_up', to: 'users#new'

  get 'dashboard', to: 'pages#dashboard'
  
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  resources :users, only: [:create]
end
