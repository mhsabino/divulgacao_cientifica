Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root 'login#index'

    resources :home, only: :index
    resources :login, only: :index
    resources :educators
  end
end
