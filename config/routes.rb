Prospector::Application.routes.draw do


  authenticated :user do
    root :to => 'home#jobboard'
    match "/jobboard" => "home#jobboard", :as => :jobboard, :via => :get
    match "/index3" => "home#index3", :as => :index3, :via => :get
    match "/dashboard" => "home#dashboard", :as => :dashboard, :via => :get
    #match "/map" => "home#map", :as => :map, :via => :get
  end

  root :to => "home#please_login"
  match "/map" => "home#map", :as => :map, :via => :get

  devise_for :users
  resources :users
  resources :nuggets do
    collection do
      post 'transition'
      get 'read_signage'
      get 'review_signage'
      get 'contact_broker'
      get 'index2'
    end
    member do
      put 'update_signage'
      get 'tag_as_blurry' # is this really a GET? It changes a nugget's state
      get 'tag_as_inappropriate' # is this really a GET? It changes a nugget's state
      get 'approve_signage'
      get 'reject_signage'
      get 'unset_editable_time' # is this really a GET? It changes a nugget's state
    end
  end

  namespace :api do
    resources :nuggets, :only => [ :create ] do
      collection do
        get 'geofind'
      end
    end
  end

  # Any other routes are handled here (as ActionDispatch prevents RoutingError from hitting ApplicationController::rescue_action).
  #match "*path", :to => "application#routing_error"
end
