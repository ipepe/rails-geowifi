Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main_page#index'

  namespace :maps do
    get :observations
    get :heat
  end
  resources :wifi_observations, only: [:index]
end
