Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main_page#index'

  namespace :maps do
    get :observations
    get :heat
  end
  resources :wifi_observations, only: [:index]
  namespace :api do
    namespace :v1 do
      resource :wifi_observation_receiver, only: [:create]
    end
  end
end
