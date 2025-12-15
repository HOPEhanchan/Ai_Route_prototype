# frozen_string_literal: true

source 'https://rubygems.org'

# ========================================
# Rails 本体
# ========================================
gem 'rails', '~> 8.1.1'

# ========================================
# アプリケーション基盤
# ========================================
gem 'bootsnap', require: false     # 起動高速化
gem 'pg', '~> 1.1'                 # PostgreSQL
gem 'puma', '>= 5.0'               # アプリケーションサーバ
gem 'sprockets-rails'              # Asset Pipeline

# ========================================
# フロントエンド / Hotwire
# ========================================
gem 'importmap-rails'              # JS管理（ESM）
gem 'stimulus-rails'               # Stimulus
gem 'tailwindcss-rails'            # TailwindCSS
gem 'turbo-rails'                  # Turbo

# ========================================
# 認証 / i18n
# ========================================
gem 'devise'                       # 認証
gem 'devise-i18n'                  # Devise の日本語化
gem 'rails-i18n'                   # Rails の日本語化

# ========================================
# JSON API
# ========================================
gem 'jbuilder'

# ========================================
# その他
# ========================================
gem 'nokogiri'
gem 'tzinfo-data', platforms: %i[windows jruby]

# ========================================
# 開発 & テスト環境
# ========================================
group :development, :test do
  gem 'brakeman', require: false # セキュリティ診断
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop-rails-omakase', require: false
end

# ========================================
# 開発専用
# ========================================
group :development do
  gem 'web-console' # エラー画面の console
end

# ========================================
# テスト専用
# ========================================
group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
