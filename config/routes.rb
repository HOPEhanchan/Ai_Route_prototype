Rails.application.routes.draw do
  root "lists#index"

  devise_for :users

  authenticate :user do
    resources :lists
  end

  get "lists/index"
end