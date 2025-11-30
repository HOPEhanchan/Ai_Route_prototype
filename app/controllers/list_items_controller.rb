# frozen_string_literal: true

class ListItemsController < ApplicationController
  before_action :set_list

  def create
    @list_item = @list.list_items.build(spot_id: params[:spot_id])

    if @list_item.save
      redirect_back fallback_location: list_path(@list),
                    notice: 'スポットをリストに追加しました。'
    else
      redirect_back fallback_location: list_path(@list),
                    alert: 'スポットをリストに追加できませんでした。'
    end
  end

  def destroy
    @list_item = @list.list_items.find(params[:id])
    @list_item.destroy

    redirect_back fallback_location: list_path(@list),
                  notice: 'リストからスポットを外しました。'
  end

  private

  def set_list
    # 自分のリストだけ操作できるよう制限する設定
    @list = current_user.lists.find(params[:list_id])
  end
end
