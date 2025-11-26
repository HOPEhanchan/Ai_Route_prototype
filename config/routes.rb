Rails.application.routes.draw do
  root "lists#index"

  devise_for :users

  get "lists/index"
end