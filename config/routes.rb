Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/profile",  to: "users#profile"
  patch "/profile", to: "users#update"

  post "/auth/register", to: "auth#register"
  post "/auth/login",    to: "auth#login"

  get "/admin/users", to: "admin#users"

  get "/transactions", to: "transactions#index"


  resources :services, only: [ :index, :show, :create, :update, :destroy ] do
  resources :requests, controller: "service_requests", only: [ :create ]
end

  delete "/auth/logout", to: "auth#logout"

  resources :requests, controller: "service_requests", only: [] do
  member do
    patch :accept
    patch :reject
    patch :cancel
    patch :complete
  end
end

get "/my-requests", to: "service_requests#my_requests"
end
