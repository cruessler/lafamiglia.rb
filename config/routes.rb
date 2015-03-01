Rails.application.routes.draw do
  devise_for :players

  resources :players, only: [ :index ] do
    collection do
      get 'search(/:query)', to: :search, as: 'search', constraints: { query: /.*/ }
    end
  end

  resources :villas, only: [ :index, :show ] do
    resources :building_queue_items, only: [ :create, :destroy ]
    resources :research_queue_items, only: [ :create, :destroy ]
    resources :unit_queue_items, only: [ :create, :destroy ]

    resources :movements, only: [ :create, :index ]
  end

  resources :movements, only: :destroy

  resources :messages, only: [ :new, :create, :index, :show, :destroy ]
  resources :reports, only: [ :index, :show, :destroy ]

  get '/map(/:x/:y)', to: 'map#show', as: :map

  root 'villas#index'
end
