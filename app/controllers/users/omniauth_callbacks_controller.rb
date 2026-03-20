# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env['omniauth.auth'])

    if user.persisted?
      sign_in user
      redirect_to authenticated_root_path, notice: 'Googleアカウントでログインしました。'
    else
      redirect_to new_user_registration_path, alert: 'Googleログインに失敗しました。'
    end
  end

  def failure
    redirect_to new_user_session_path, alert: 'Googleログインに失敗しました。時間をおいて再試行してください。'
  end
end
