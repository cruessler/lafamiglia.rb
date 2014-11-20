Rails.application.routes.draw do
  devise_for :players

  resources :villas, only: [ :index, :show ] do
    resources :building_queue_items, only: [ :create, :destroy ]
  end

  root 'villas#index'
end
