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
    resources :events, only: :create, controller: "plan_events"
    resources :supplementary_documents, only: [ :new, :create ]
    resource :post_event_treatment_report, only: [ :create, :update, :show ] do
      resources :treatment_records, only: [ :new, :create ]
      resources :transportation_records, only: [ :new, :create ]
    end
    post '/update_acceptance/', to: 'plans#update_acceptance', as: :update_acceptance
  end
  resources :post_event_treatment_reports, only: :none do
    resources :supplementary_documents, only: [ :new, :create ]
  end
  resources :treatment_records, only: [ :edit, :update, :destroy ]
  resources :transportation_records, only: [ :edit, :update, :destroy ]
  resources :comments do
    resources :replies, only: :create
  end
  resources :event_types
  resources :notification_groups, only: [ :show, :update ]
  resources :notifications, only: :update
  resources :operation_periods, only: [ :update, :destroy ] do
    resources :clones, only: :create
    resources :first_aid_stations, only: [ :new, :create ]
    resources :mobile_teams, only: [ :new, :create ]
    resources :dispatches, only: [ :new, :create ]
    resources :transports, only: [ :new, :create ]
  end
  resources :providers
  resources :provider_confirmations
  resources :permitters
  resources :venues
  resources :supplementary_documents, only: [ :destroy ]
  resources :organizations

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
  get "/learn_more" => 'home#learn_more', as: 'learn_more'

  get 'admin', to: 'admin#index'
  
end
