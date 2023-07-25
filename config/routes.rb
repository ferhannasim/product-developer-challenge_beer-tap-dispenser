Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'users', to: 'users#create'
      post 'login', to: 'authentication#login'
    end
  end
  resources :dispensers do
    resources :tap_events, only: [:create, :update]
  end
end
