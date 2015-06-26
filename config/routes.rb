Rails.application.routes.draw do
  root to: "home#index"
  resources :plans do
    member do
      post :add_comment
      post :resolve_comment
      post :request_revision
      post :approve
    end
  end
  resources :event_types
  resources :providers
  resources :permitters

  devise_for :users

  get "/add_first_aid_station" => 'plans#add_first_aid_station', as: 'add_first_aid_station'
  get "/add_operation_period/:count" => 'plans#add_operation_period', as: 'add_operation_period'


 
end
