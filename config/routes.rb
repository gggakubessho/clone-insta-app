# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  
  get 'home/index'
  get 'home/show'
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
    get 'sign_out', to: 'users/sessions#destroy'
  end

  resources :users, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end
  
  resources :images, only: [:index,:new,:create] 
end
