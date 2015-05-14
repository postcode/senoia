Rails.application.routes.draw do
  root to: "home#index"
  resources :plans
  resources :event_types
  resources :providers
  resources :permitters

  devise_for :users
 
end
