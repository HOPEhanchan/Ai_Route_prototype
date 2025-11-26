# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  allow_browser versions: :modern

  private

  # ログイン後の遷移先
  def after_sign_in_path_for(_resource)
    root_path
  end

  # ログアウト後の遷移先
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
