Rails.application.routes.draw do
  devise_for :players

  resources :villas, only: [ :index, :show ]

  root 'villas#index'
end
