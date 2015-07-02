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
  get "/add_mobile_team" => 'plans#add_mobile_team', as: 'add_mobile_team'
  get "/add_transport" => 'plans#add_transport', as: 'add_transport'
  get "/add_dispatch" => 'plans#add_dispatch', as: 'add_dispatch'
  get "/add_operation_period/:count" => 'plans#add_operation_period', as: 'add_operation_period'


 
end
