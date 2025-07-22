Rails.application.routes.draw do
  get 'homepage', to: 'homepage#index'
  get  'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get  'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'
  resources :sessions, only: %i[index show destroy]
  resource  :password, only: %i[edit update]
  namespace :identity do
    resource :email,              only: %i[edit update]
    resource :email_verification, only: %i[show create]
    resource :password_reset,     only: %i[new edit create update]
  end

  root 'homepage#index'

  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'addresses/new', to: 'addresses#new', as: :new_address
  post 'addresses/create', to: 'addresses#create', as: :create_address

  resources :plans, only: [:index]
end
