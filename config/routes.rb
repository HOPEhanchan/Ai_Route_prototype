Rails.application.routes.draw do
  root 'lists#index'

  devise_for :users

  authenticate :user do
    resources :lists
  end

  # Render スリープ対策用のヘルスチェック
  get 'healthcheck', to: proc { [200, { 'Content-Type' => 'text/plain' }, ['ok']] }
end
