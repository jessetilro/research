Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'sessions/sessions'
  }

  root to: 'projects#index'

  resources :projects, only: [:index] do
    resources :sources
    resources :tags, only: [:index, :create, :update, :destroy]
    resource :export, only: :show
    resources :source_imports, only: :create
    resources :stars, only: [:create, :destroy]
    resources :reviews, only: [:create, :update, :destroy]
    resources :review_previews, only: :index
  end

end
