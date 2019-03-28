Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: :registrations
  }

  root to: 'sources#index'

  resource :welcome, only: :show

  resources :sources, only: [:show, :index]

  resources :projects, only: [:index, :show, :create, :new] do
    resources :sources
    resources :tags, only: [:index, :create, :update, :destroy]
    resource :export, only: :show
    resources :source_imports, only: :create
    resource :source_drops, only: [:create, :show]
    resources :stars, only: [:create, :destroy]
    resources :reviews, only: [:create, :update, :destroy]
    resources :review_previews, only: :index
    resources :queries
  end
end
