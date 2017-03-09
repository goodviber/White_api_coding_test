Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :events, except: [:new, :edit]
      resources :users, only: [:create]
    end
  end
end
