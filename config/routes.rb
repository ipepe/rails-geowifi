Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'main_page#index'

  root 'maps#observations'

  (StaticController::PAGES + [:mobile_app]).each do |page|
    get page, controller: 'static'
  end

  namespace :maps do
    get :observations
    get :all_observations
    # get :heat
  end
  resources :wifi_positions, only: [:show, :index]
  namespace :api do
    namespace :v1 do
      resource :wifi_observation_receiver, only: [:create]
      resource :geolocate, only: [:create]
    end
  end
end
