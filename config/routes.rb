Rails.application.routes.draw do
  authenticated :user do
    root to: 'mypage#show', as: :authenticated_root

    resources :points, only: %i[index show create]
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
    unlocks: 'users/unlocks'
  }
  namespace :users do
    resources :user_auths, param: :provider, except: [:update]
  end

  namespace :mypage do
    resource :avatar, only: %i[edit update], controller: 'avatar'
  end

  namespace :api do
    namespace :users do
      resource :registrations, only: %i[show create update destroy]
      resource :sessions, only: %i[create destroy]
      resources :user_auths, param: :provider, only: %i[create destroy]
    end
  end

  root to: 'home#index'
end
