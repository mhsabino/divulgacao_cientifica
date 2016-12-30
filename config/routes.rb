Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root 'home#index'

    resources :courses
    resources :educators
    resources :home, only: :index
    resources :login, only: :index
    resources :school_classes
    resources :students
  end
end
