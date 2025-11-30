Rails.application.routes.draw do
  get "profiles/show"
  get "profiles/edit"
  root 'lists#index'

  devise_for :users

  authenticate :user do
    resources :lists
    resources :spots
    resource :profile, only: %i[show edit update]
  end

  # Render スリープ対策用のヘルスチェック
  get 'healthcheck', to: proc { [200, { 'Content-Type' => 'text/plain' }, ['ok']] }
end
