Rails.application.routes.draw do
  
  get 'sign_in', to: 'sessions#new'
  get 'sign_up', to: 'users#new'
  
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  resources :users, only: [:create]
end
