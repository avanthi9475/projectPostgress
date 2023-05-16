Rails.application.routes.draw do
  devise_for :user_logins,  controllers: { registrations: 'registrations'}
  resources :messages
  resources :logins
  resources :complaints
  resources :officers
  resources :users
  resources :admins

  devise_scope :user_login do
    root to: 'sessions#new'
  end
  
  post '/submit' => "signups#create"

  get '/viewMyComplaints' => "complaints#mycomplaints"

  get '/viewRequestMsg' => "officers#viewRequestMsg"

  get '/respondMsg/:id' => "messages#respondMsg"

  get '/viewResponse' => "users#viewResponse"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
