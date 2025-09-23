# frozen_string_literal: true

Rails.application.routes.draw do
  get 'homepage', to: 'homepage#index'
  get  'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get  'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'
  get 'home', to: 'home#index'
  resources :sessions, only: %i[index show destroy]
  resource  :password, only: %i[edit update]
  namespace :identity do
    resource :email,              only: %i[edit update]
    resource :email_verification, only: %i[show create]
    resource :password_reset,     only: %i[new edit create update]
  end

  root 'homepage#index'

  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :addresses, only: %i[new create]

  resources :plans, only: [:index]
end
