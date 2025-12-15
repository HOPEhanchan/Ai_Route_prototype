# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :load_sign_up_params_from_session, only: :confirm, if: -> { request.get? }

    def confirm
      return store_params_and_redirect_to_confirm if request.post?
      return redirect_to_new_signup unless @sign_up_params

      build_resource(@sign_up_params)
      resource.validate
      return render_new_with_errors if resource.errors.any?

      render :confirm
    end

    def create
      params_hash = session.delete(:sign_up_params)
      return redirect_to_new_signup unless params_hash

      build_resource(params_hash)
      save_and_respond
    end

    private

    def save_and_respond
      resource.save

      if resource.persisted?
        sign_up(resource_name, resource)
        redirect_to after_sign_up_path_for(resource)
      else
        render_new_after_failed_save
      end
    end

    def render_new_after_failed_save
      clean_up_passwords(resource)
      render :new, status: :unprocessable_entity
    end

    def store_params_and_redirect_to_confirm
      session[:sign_up_params] = sign_up_params.to_h
      redirect_to confirm_user_registration_path
    end

    def load_sign_up_params_from_session
      @sign_up_params = session[:sign_up_params]
    end

    def redirect_to_new_signup
      redirect_to new_user_registration_path, alert: 'もう一度入力してください'
    end

    def render_new_with_errors
      clean_up_passwords(resource)
      render :new, status: :unprocessable_entity
    end

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
