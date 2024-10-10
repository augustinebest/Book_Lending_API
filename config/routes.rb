Rails.application.routes.draw do
  get "authentication/signup"
  post "authentication/login"

  resources :books, only: [:index, :create, :show, :update, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
