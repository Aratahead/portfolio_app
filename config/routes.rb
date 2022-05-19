Rails.application.routes.draw do
  root to: 'posts#index'
  devise_for :users
  resources :posts
  get 'search_tag', to: 'posts#search_tag'
  get '/toppages', to: 'toppages#index'
end
