Slinky::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :links, only: [:new, :create, :destroy]

  root :to => 'home#index'

  match '/login/' => "sessions#new"
  match '/logout/' => "sessions#destroy"
  match '/signup/' => "users#new"
  match '/dashboard/' => "users#dashboard"
  match '/profile/' => "users#profile"
  match '*a' => "links#check_for_valid_link"

end
