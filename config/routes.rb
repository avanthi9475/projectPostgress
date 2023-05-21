Rails.application.routes.draw do
  resources :crime_firs
  resources :feedbacks
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :user_logins,  controllers: { registrations: 'user_logins/registrations' , sessions: 'user_logins/sessions'}
  resources :messages
  resources :logins
  resources :complaints
  resources :officers
  resources :users
  resources :heads

  devise_scope :user_login do
    root to: 'sessions#new'
  end
  
  post '/submit' => "signups#create"

  get '/viewMyComplaints' => "complaints#mycomplaints"

  get '/viewRequestMsg' => "officers#viewRequestMsg"

  get '/respondMsg/:id' => "messages#respondMsg"

  get '/handledByOfficer/:id' => "complaints#handledByOfficer"

  get '/viewResponse' => "users#viewResponse"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html





  namespace :api ,default: {format: :json} do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    devise_for :user_logins,  controllers: { registrations: 'user_logins/registrations' , sessions: 'user_logins/sessions'}
    resources :messages
    resources :logins
    resources :complaints
    resources :officers
    resources :users
    resources :heads

    devise_scope :user_login do
      root to: 'sessions#new'
    end
    
    post '/submit' => "signups#create"

    get '/viewMyComplaints' => "complaints#mycomplaints"

    get '/viewRequestMsg' => "officers#viewRequestMsg"

    get '/respondMsg/:id' => "messages#respondMsg"

    get '/handledByOfficer/:id' => "complaints#handledByOfficer"

    get '/viewResponse' => "users#viewResponse"
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
end
