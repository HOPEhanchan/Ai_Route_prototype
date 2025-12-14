# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    private

    def require_admin!
      return if current_user.admin?

      render file: Rails.root.join('public/403.html'), status: :forbidden, layout: false
    end
  end
end
