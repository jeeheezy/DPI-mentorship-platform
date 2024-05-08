Rails.application.routes.draw do
  root "home#index"
  resources :pairings
  resources :participations, except: %i[index, show]
  resources :programs do
    # oh cool! very detail oriented
    get "/index" => "programs/participations#index", as: :participations_index
    post "/create" => "programs/rankings#create", as: :create_rankings
    # using post here instead of patch since for create I'm scorching earth and creating anew
    post "/update" => "programs/rankings#update", as: :update_rankings
  end
  devise_for :users, controllers: { registrations: 'registrations' }

  get "/users/:user_id" => "users#show", as: :user
  # you can remove these comments
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
