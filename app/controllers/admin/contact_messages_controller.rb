# frozen_string_literal: true

class Admin::ContactMessagesController < Admin::BaseController
  def index
    @contact_messages = ContactMessage.order(created_at: :desc)
  end

  def show
    @contact_message = ContactMessage.find(params[:id])
  end

  def destroy
    @contact_message = ContactMessage.find(params[:id])
    @contact_message.destroy!
    redirect_to admin_contact_messages_path, notice: "お問い合わせを削除しました"
  end
end
