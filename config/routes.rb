Rails.application.routes.draw do
  devise_for :users

  root to: 'sources#index'

  resources :sources
  resources :stars, only: [:create, :destroy]
  resource :export, only: :show
  resources :source_imports, only: :create
end
