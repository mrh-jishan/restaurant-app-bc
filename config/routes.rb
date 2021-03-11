Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :auth, only: [:create]
      resources :restaurants, only: [:index]
      resources :favourites, only: [:create, :index]
    end
  end

  root :to => 'application#index'

end
