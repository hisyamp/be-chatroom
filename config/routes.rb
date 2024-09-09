Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :chatrooms
    end
  end
end
