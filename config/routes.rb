Rails.application.routes.draw do
  get "tags/show"
  get "votes/create"

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
    get "/users/sign_out" => "devise/sessions#destroy"
  end

  get "home/index"
  get "home/about"
  get "home/sandbox"

  get "ozone/index"
  post "zipcode" => "ozone#zipcode"

  resources :stories do
    resources :reactions, only: [ :create ]

    put "/stories/:id/like" => "stories#like", as: "like"

    resources :votes

    collection do
      post :import
    end
  end

  resources :tags   # ✅ only once

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "home#index"
end
