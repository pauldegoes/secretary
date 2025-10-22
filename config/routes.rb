Rails.application.routes.draw do
  # Root route
  root 'home#index'
  
  # Authentication routes
  get '/auth/:provider', to: 'auth#passthru', as: :auth_provider
  get '/auth/:provider/callback', to: 'auth#callback'
  get '/auth/failure', to: 'auth#failure'
  get '/signout', to: 'sessions#destroy', as: :signout
  
  # Dashboard
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  
  # Projects
  resources :projects do
    member do
      patch :update
    end
  end
  
  # Profile
  get '/profile', to: 'profile#show', as: :profile
  patch '/profile', to: 'profile#update'
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
