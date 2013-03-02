Rails3BootstrapDeviseCancan::Application.routes.draw do


  authenticated :user do
    root :to => 'home#dashboard'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :nuggets


  # Any other routes are handled here (as ActionDispatch prevents RoutingError from hitting ApplicationController::rescue_action).
  match "*path", :to => "application#routing_error"
end
