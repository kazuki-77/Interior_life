# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  root to: 'homes#top'
  get '/about' => 'homes#about'
  get 'search' => 'searches#search'
  get 'chat/:id' => 'chats#show', as: '/chat'
  resources :chats, only: [:create]

  resources :users, only: %i[show edit update index] do
    resource :relationships, only: %i[create destroy]
    get :followings, on: :member # on: :memberでルーティングにidを含めることができる
    get :followers, on: :member
  end

  resources :post_images, only: %i[new create index show destroy] do
    # showページが不要、idの受け渡しもないのでresourceと記述
    resource :favorites, only: %i[create destroy]
    resources :post_comments, only: %i[create destroy]
  end
end
