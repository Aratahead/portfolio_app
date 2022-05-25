# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "toppages#index"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords"
  }
  resources :posts
  get "search_tag", to: "posts#search_tag"
  post "/review_complete/:id", to: "posts#review_complete", as: "review_complete"
  delete "/review_incomplete/:id", to: "posts#review_incomplete", as: "review_incomplete"
  get "/toppages", to: "toppages#index"
  devise_scope :user do
    post "user/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
end
