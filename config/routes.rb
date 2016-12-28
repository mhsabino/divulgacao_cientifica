Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root 'home#index'

    resources :home, only: :index
    resources :login, only: :index
    resources :educators
    resources :courses
    resources :school_classes
  end
end
