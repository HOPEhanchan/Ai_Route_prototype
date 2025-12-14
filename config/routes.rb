Rails.application.routes.draw do
  get "contact_messages/new"
  get "contact_messages/create"
  # 未ログイン時の root
  root 'static_pages#landing'
  # ログイン前後どっちでも見られる説明ページ
  get '/about', to: 'static_pages#landing', as: :about
  get '/terms',   to: 'static_pages#terms',   as: :terms
  get '/privacy', to: 'static_pages#privacy', as: :privacy

  # ログイン後の root
  authenticated :user do
    root 'lists#index', as: :authenticated_root
  end

  devise_for :users

  authenticate :user do
    resources :lists do
      resources :list_items, only: %i[create destroy]
      resources :spots, only: :index, module: :lists
    end

    resources :spots do
      collection do
        get :fetch_metadata
      end
    end

    resource :profile, only: %i[show edit update]

    resource :contact_messages, only: [:new, :create]
  end

  # Render スリープ対策用のヘルスチェック
  get 'healthcheck',
      to: proc { [200, { 'Content-Type' => 'text/plain' }, ['ok']] }
end
