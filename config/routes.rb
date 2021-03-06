Rails.application.routes.draw do
  devise_for :players

  resources :players, only: [ :index, :show ] do
    collection do
      get 'search(/:query)', action: :search, as: 'search', constraints: { query: /.*/ }
    end
  end

  resources :villas, only: [ :index, :show ] do
    resources :building_queue_items, only: [ :create, :destroy ]
    resources :research_queue_items, only: [ :create, :destroy ]
    resources :unit_queue_items, only: [ :create, :destroy ]

    resources :movements, only: [ :create, :index ], controller: 'villas/movements'
  end

  resources :movements, only: [ :index, :destroy ]
  resources :occupations, only: [ :destroy ]

  resources :messages, only: [ :new, :create, :index, :show, :destroy ]
  resources :reports, only: [ :index, :show, :destroy ]

  get '/map(/:x/:y)', to: 'map#show', as: :map

  root 'villas#index'
end
