# frozen_string_literal: true

class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new(
      email: current_user.email,
      name: current_user.profile
    )
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      redirect_to new_contact_messages_path, notice: 'お問い合わせを送信しました！'
    else
      flash.now[:alert] = '入力内容を確認してください'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :body)
  end
end
