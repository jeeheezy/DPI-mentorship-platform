Rails.application.routes.draw do
  resources :rankings
  resources :pairings
  resources :participations
  resources :programs
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
