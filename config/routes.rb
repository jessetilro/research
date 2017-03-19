Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'sessions/sessions'
  }

  root to: 'sources#index'

  resources :sources
  resources :tags, only: [:index, :create, :update, :destroy]
  resources :stars, only: [:create, :destroy]
  resources :reviews, only: [:create, :update, :destroy]
  resources :review_previews, only: :index
  resource :export, only: :show
  resources :source_imports, only: :create
end
