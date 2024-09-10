Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :chatrooms do
        resources :messages, only: [:index, :create, :show, :update, :destroy]
      end
    end
  end
end
