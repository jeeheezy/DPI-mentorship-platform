Rails.application.routes.draw do
  root "home#index"
  # resources :rankings
  resources :pairings
  resources :participations, except: %i[index] 
  resources :programs do
    # resources :rankings, only: %i[create destroy update]
    get "/index" => "programs/rankings#index", as: :rankings_index
    post "/create" => "programs/rankings#create", as: :create_rankings
    # using post here instead of patch since for create I'm scorching earth and creating anew
    post "/update" => "programs/rankings#update", as: :update_rankings
  end
  devise_for :users, controllers: { registrations: 'registrations' }

  get "/users/:user_id" => "users#show", as: :user
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
