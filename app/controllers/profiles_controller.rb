# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_user

  def show; end

  def edit; end

  def update
    if @user.update(profile_params)
      redirect_to profile_path, notice: 'プロフィールを更新しました。'
    else
      flash.now[:alert] = 'プロフィールの更新に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:user).permit(:name, :avatar_url, :profile)
  end
end
