Rails.application.routes.draw do
  root to: "home#index"
  resources :plans do
    member do
      post :add_comment
    end
  end
  resources :event_types
  resources :providers
  resources :permitters

  devise_for :users


 
end
