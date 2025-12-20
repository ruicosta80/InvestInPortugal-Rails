Rails.application.routes.draw do
  # Devise routes must be outside the namespace block
  devise_for :admin_users, skip: [:registrations], controllers: { 
  sessions: 'admin_users/sessions' 
}

  # Define the public routes (homepage and form submission)
  root "home#index"
  resources :leads, only: [:new, :create]

  # Admin Backend Namespace
  namespace :admin do
    # Sets the default path for /admin to the leads list
    root "leads#index" 
    # Defines resource routes for leads (e.g., /admin/leads)
    resources :leads, only: [:index,:show, :destroy] do
      # NEW: Creates GET /admin/leads/export
      collection { get :export }
    end
  end

  # Health check should stay
  get "up" => "rails/health#show", as: :rails_health_check
  # Add this line at the bottom, just before the final 'end'
  get 'admin_dashboard', to: 'leads#index'
end
