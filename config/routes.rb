Rails.application.routes.draw do
  devise_for :users

  root 'admin#index'


  namespace :admin do
    root 'home#index'

    resources :home, only: :index
    resources :login, only: :index
    resources :educators
  end
end
