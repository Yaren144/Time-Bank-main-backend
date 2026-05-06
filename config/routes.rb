Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/profile",  to: "users#profile"
  patch "/profile", to: "users#update"

  post "/auth/register", to: "auth#register"
  post "/auth/login",    to: "auth#login"

  get    "/admin/users",             to: "admin#users"
  patch  "/admin/users/:id/toggle",  to: "admin#toggle_user"
  get    "/admin/services",          to: "admin#services"
  patch  "/admin/services/:id/toggle", to: "admin#toggle_service"
  delete "/admin/services/:id",      to: "admin#delete_service"
  get    "/admin/transactions",      to: "admin#transactions"
  get    "/admin/balances",          to: "admin#balances"

  get "/transactions", to: "transactions#index"


  resources :services, only: [ :index, :show, :create, :update, :destroy ] do
  resources :requests, controller: "service_requests", only: [ :create ]
end
  resources :reviews, only: [ :create, :index ]

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
