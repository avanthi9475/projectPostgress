Rails.application.routes.draw do

  use_doorkeeper
  resources :crime_firs
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

  post '/handledByOfficer/:id' => "complaints#assign_new_officer"

  get '/viewResponse' => "users#viewResponse"

  post  "/remove_officer/:id" => "complaints#remove_officer"

  post "/make_as_lead/:id" => "complaints#make_head"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :api do
    use_doorkeeper do
        skip_controllers :applications, :authorizations, :authorized_applications
    end
  end

  use_doorkeeper do
    skip_controllers :authorizations, :authorized_applications
  end

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
    resources :crime_firs

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
