Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'users#new', as: :new_user
  get :join, to: 'users#show', as: :join
  post :create, to: 'users#create', as: :create
  get :destroy, to: 'users#destroy', as: :destroy
  mount ActionCable.server, at: '/cable'

  scope '/.well-known', controller: :health do
    get :health_check
  end
end
