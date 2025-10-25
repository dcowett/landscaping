Rails.application.routes.draw do
  resources :properties do
    resources :notes, except: [:index], controller: "properties/notes"

    collection do
      post :import
    end
  end

  resources :notes, :only => [:index]

  resources :addresses do
    collection do
      post :import
    end
  end

  resources :pins
  devise_for :users

  devise_scope :user do
   get "/users/sign_out" => "devise/sessions#destroy"
  end

  get "home/index"

  get "home/about"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
