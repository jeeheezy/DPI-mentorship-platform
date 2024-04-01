Rails.application.routes.draw do
  root "programs#index"
  resources :rankings
  resources :pairings
  resources :participations 
  resources :programs do
    resources :rankings, only: %i[create destroy update]
  end
  devise_for :users

  get ":username" => "users#show", as: :user
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
