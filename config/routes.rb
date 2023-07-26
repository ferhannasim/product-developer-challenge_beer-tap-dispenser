Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'users', to: 'users#create'
      post 'login', to: 'authentication#login'
    end
  end
  resources :dispensers do
    collection do
      get 'usage_details'
    end
    resources :tap_events, only: [:create, :update] do 
      collection do
        get 'usage_details'
      end
    end

  end
end
