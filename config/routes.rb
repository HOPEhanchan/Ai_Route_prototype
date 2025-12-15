Rails.application.routes.draw do
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

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  devise_scope :user do
    get  "users/sign_up/confirm", to: "users/registrations#confirm", as: :confirm_user_registration
    post "users/sign_up/confirm", to: "users/registrations#confirm"
  end

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

    # 一般ユーザーのお問い合わせ（new/create）
    resource :contact_messages, only: %i[new create]

    # 管理画面（一覧・詳細）
    namespace :admin do
      resources :contact_messages, only: %i[index show destroy]
    end
  end

  # Render スリープ対策用のヘルスチェック
  get 'healthcheck',
      to: proc { [200, { 'Content-Type' => 'text/plain' }, ['ok']] }
end
