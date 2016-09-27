Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root to: 'home#index'

    resources :home, only: :index
  end
end
