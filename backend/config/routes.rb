Rails.application.routes.draw do
resources :tasks, only:[:index, :show, :create, :update, :destroy]
resources :sessions, only:[:create]
resources :users, only:[:create]

  get "up" => "rails/health#show", as: :rails_health_check
  get "me" => "sessions#me"
  delete "logout" => "sessions#destroy"

end
