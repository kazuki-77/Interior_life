Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get '/about' => 'homes#about'

  get 'chat/:id' => 'chats#show', as: '/chat'
  resources :chats, only: [:create]

  resources :users, only: [:show, :edit, :update, :index] do
    resource :relationships, only: [:create, :destroy]
    get :followings, on: :member # on: :memberでルーティングにidを含めることができる
    get :followers, on: :member
  end

  resources :post_images, only: [:new, :create, :index, :show, :destroy] do
    # showページが不要、idの受け渡しもないのでresourceと記述
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

end
