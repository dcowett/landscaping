Rails.application.routes.draw do

  resources :properties do
    resources :notes, except: [ :index ], controller: "properties/notes"

    collection do
      post :import
    end
  end

  resources :notes, only: [ :index, :new ] do
    collection do
      post :import
    end
  end

  resources :pins

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy"
  end

  get "home/index"
  get "home/about"
  get "home/sandbox"

  get "ozone/index"
  post "zipcode", to: "ozone#zipcode"

resources :stories do
    resources :reactions, only: [:create]
    resources :votes

    member do
      put :like
    end

    collection do
      post :import
    end
  end

  resources :tags   # ✅ only once

  get "up", to: "rails/health#show", as: :rails_health_check

  root to: "home#index"
end
