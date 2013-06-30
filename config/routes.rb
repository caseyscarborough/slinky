Slinky::Application.routes.draw do
  resources :users

  root :to => 'home#index'

  match '/' => "home#index"
  match '/login' => "session#login"
  match '/signup' => "users#new"

end
