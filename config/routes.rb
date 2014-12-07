Rails.application.routes.draw do
  
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'sign_up', to: 'users#new'

  get 'dashboard', to: 'pages#dashboard'
  get 'mentor_queue', to: 'queue_items#index'
  
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  resources :users, only: [:create]
  resources :languages, only: [:show]
  resources :skills, only: [:new, :create]
  resources :queue_items, only: [:create]
end
