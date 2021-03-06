Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :collaborates, only: [:show]
      resources :users, only: [:create]
      resources :auth, only: [:create]
      resources :restaurants, only: [:index]
      resources :favourites, only: [:create, :index, :destroy, :update]
      resources :invitations, only: [:create, :index, :show]
    end
  end

  root :to => 'application#index'

end
