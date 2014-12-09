Rails.application.routes.draw do
  
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'sign_up', to: 'users#new'

  get 'dashboard', to: 'languages#index'
  get 'mentoring_sessions', to: 'mentoring_sessions#index'
  
  root 'languages#front'

  get 'ui(/:action)', controller: 'ui'
  resources :users, only: [:create, :show]
  resources :languages, only: [:show]
  resources :skills, only: [:new, :create] do
    resources :feedbacks, only: [:index]
  end
  resources :mentoring_sessions, only: [:create, :destroy] do
    collection do
      patch 'update', to: "mentoring_sessions#update_sessions", as: :update
    end

    resources :feedbacks, only: [:new, :create]
  end

end
