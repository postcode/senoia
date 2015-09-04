Rails.application.routes.draw do
  root to: "home#index"
  resources :plans do
    member do
      post :request_revision
      post :approve
      delete 'remove_user(/:plan_id/:user_id)', :to => 'plans#remove_user', :as => :remove_user
    end
    resources :comments, only: :create
    resources :invitations, only: :create
    resources :operation_periods, only: [ :new, :create ]
  end
  resources :comments do
    resources :replies, only: :create
  end
  resources :event_types
  resources :operation_periods, only: :destroy do
    resources :clones, only: :create
    resources :first_aid_stations, only: [ :new, :create ]
  end
  resources :providers
  resources :permitters

  devise_for :users
  resources :users

  post "/add_first_aid_station/:operation_period" => 'plans#add_first_aid_station', as: 'add_first_aid_station'
  post "/update_first_aid_station/:operation_period" => 'plans#update_first_aid_station', as: 'update_first_aid_station'
  get "/add_mobile_team/:operation_period" => 'plans#add_mobile_team', as: 'add_mobile_team'
  get "/add_transport/:operation_period" => 'plans#add_transport', as: 'add_transport'
  get "/add_dispatch/:operation_period" => 'plans#add_dispatch', as: 'add_dispatch'
  get "/add_operation_period/:count" => 'plans#add_operation_period', as: 'add_operation_period'
  post "/add_user_plan" => 'plans#add_user', as: 'add_user_plan'
  post "/update_user_plan" => 'plans#update_plan_user', as: 'update_user_plan'

end
