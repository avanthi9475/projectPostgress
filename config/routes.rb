Rails.application.routes.draw do
  resources :logins
  resources :complaints
  resources :officers
  resources :users
  resources :admins

  root to: "signups#index"
  get '/signups' => "signups#index"

  post '/submit' => "signups#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
