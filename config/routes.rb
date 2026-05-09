Rails.application.routes.draw do
  get "movies/index"
  get "movies/new"
  get "movies/create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :movies, only: [:index, :new, :create]

  resources :lists, only: [:index, :show, :new, :create, :edit, :update] do
    resources :bookmarks, only: [:create]
    resources :reviews, only: [:create, :destroy]
  end

  resources :bookmarks, only: [:destroy]
end
