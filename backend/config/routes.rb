Rails.application.routes.draw do
resources :tasks, only:[:index, :show, :create, :update, :destroy]
  get "up" => "rails/health#show", as: :rails_health_check


end
