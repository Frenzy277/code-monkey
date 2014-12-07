Rails.application.routes.draw do
  
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'sign_up', to: 'users#new'

  get 'dashboard', to: 'pages#dashboard'
  get 'mentor_queue', to: 'queue_items#index'
  
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  resources :users, only: [:create, :show]
  resources :languages, only: [:show]
  resources :skills, only: [:new, :create]
  resources :queue_items, only: [:create, :destroy] do
    collection do
      patch 'update_queue', to: "queue_items#update_queue", as: :update
    end
  end

end
