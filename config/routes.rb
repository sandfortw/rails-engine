# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#show'
      get 'merchants/find_all', to: 'merchants/search#index'

      get 'items/find_all', to: 'items/search#index'

      resources :merchants, only: %i[index show] do
        resources :items, only: :index, controller: 'merchants/items'
      end
      resources :items do
        resources :merchants, only: :index, controller: 'items/merchants', as: 'merchant', path: 'merchant'
      end
    end
  end
end
