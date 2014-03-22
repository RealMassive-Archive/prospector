Prospector::Application.routes.draw do

  # Mount resque's UI:
  authenticate :user do
    mount Resque::Server.new, :at => "/resque"
  end

  authenticated :user do
    root :to => 'home#jobboard'
    match "/jobboard" => "home#jobboard", :as => :jobboard, :via => :get
    match "/index3" => "home#index3", :as => :index3, :via => :get
    match "/dashboard" => "home#dashboard", :as => :dashboard, :via => :get
    delete  '/admin/purge' => 'admin#purge', as: :purge
    get     '/admin'       => 'admin#index', as: :admin
    get '/api-listings/new' => 'api_listings#new'
    resources :buildings, except: [:edit, :update, :destroy]
    get '/buildings/search/:street/:city/:state/:zipcode' => 'buildings#search'
  end

  root :to => "home#please_login"
  match "/map" => "home#map", :as => :map, :via => :get

  devise_for :users
  resources :users
  resources :nuggets, only: [:index, :show, :destroy] do
    collection do
      post 'transition'
      get 'read_signage'
      get 'review_signage'
      get 'dedupe_signage'
      get 'contact_broker'
      get 'parse_broker_email'
    end
    member do
      put 'update_signage'
      get 'tag_as_blurry' # is this really a GET? It changes a nugget's state
      get 'tag_as_inappropriate' # is this really a GET? It changes a nugget's state
      get 'approve_signage'
      get 'reject_signage'
      get 'unset_editable_time' # is this really a GET? It changes a nugget's state
      post 'dedupe' # to mark duplicate nuggets state
      post 'signage_unique'
      post "save_call"
      get  "add_nugget_tab"
    end
  end

  resources :broker_emails,:only=>[:update, :destroy] do
    collection do
      get 'parse'
    end
    member do
      get "add_nugget_tab"
    end
  end
  resources :listing_nuggets, :only=>[:update] do
    collection do
      post "add_attachment"
    end
  end
  namespace :api do
    resources :nuggets, :only => [ :create ] do
      collection do
        get 'geofind'
      end
    end
    resources :broker_emails,:only=>[:create]
  end
  resources :listings do
    collection do
      get "extract_listing"
    end
  end
end
