Rails.application.routes.draw do
  resources :rankings
  resources :pairings
  resources :participants
  resources :programs
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
