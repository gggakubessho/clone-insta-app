# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
    get 'sign_out', to: 'users/sessions#destroy'
  end

  get 'home/index'
  get 'home/show'

  root to: 'home#index'
  resources :users, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end
end
