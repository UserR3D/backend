Rails.application.routes.draw do
  resources :users
  post "/login", to: "users#login"
  get "user", to: "users#show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
