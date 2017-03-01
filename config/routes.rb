Rails.application.routes.draw do
  devise_for :users

  root to: 'sources#index'

  resources :sources
  resources :approvals, only: [:create, :destroy]
end
