Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
    unlocks: 'users/unlocks'
  }
  namespace :users do
    resources :user_auths, param: :provider, only: %i[show new create destroy]
  end

  root to: 'home#index'
end
