Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'users#new', as: :new_user
  get :join, to: 'users#show', as: :join
  post :create, to: 'users#create', as: :create
  post 'users/:user_name', to: 'users#update', as: :update
  mount ActionCable.server, at: '/cable'
end
