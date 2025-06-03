Rails.application.routes.draw do
  root to: 'pages#home'
  get 'mom_midwife_signup', to: 'pages#new_mom_midwife', as: :new_mom_midwife

  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :midwives do
    resources :bookings
  end

  resources :bookings do
    resources :appointments, except: [:destroy]
    resources :messages, only: :create
  end

  resources :appointments, only: [:destroy]
  resources :moms do
    resources :notes, only: [:new, :create]
  end

  resources :notes, only: [:edit, :update, :destroy]

  get 'search', to: 'pages#search', as: :search
  get 'calendar', to: 'pages#calendar', as: :calendar
  get 'chatrooms', to: 'pages#chatrooms', as: :chatrooms
  patch 'bookings/:id/accepted', to: 'bookings#accepted', as: 'accepted'
  patch 'bookings/:id/cancelled', to: 'bookings#cancelled', as: 'cancelled'
  patch 'bookings/:id/cancelled_user', to: 'bookings#cancelled_user', as: 'cancelled_user'
  patch 'bookings/:id/appointments/:id/cancelled_appointment', to: 'appointments#cancelled_appointment', as: 'cancelled_appointment'
    # Mount Action Cable for WebSockets
  mount ActionCable.server => '/cable'
end
