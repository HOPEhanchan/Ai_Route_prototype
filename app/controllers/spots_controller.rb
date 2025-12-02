# frozen_string_literal: true

class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_spot, only: %i[show edit update destroy]

  def index
    @lists = current_user.lists.order(created_at: :desc)
    @current_list = current_user.lists.find_by(id: params[:list_id])
    @spots = fetch_spots
  end

  def show; end

  def new
    @spot = current_user.spots.new
  end

  def create
    @spot = current_user.spots.new(spot_params)

    if @spot.save
      redirect_to spots_path, notice: '行きたいスポットを登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @spot = current_user.spots.find(params[:id])
  end

  def update
    if @spot.update(spot_params)
      redirect_to spot_path(@spot), notice: 'スポット情報を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @spot.destroy
    redirect_to spots_path, notice: 'スポットを削除しました。'
  end

  def fetch_metadata
    url = params[:url].to_s

    if url.blank?
      render json: { error: 'URLが空です' }, status: :unprocessable_entity
      return
    end

    render json: formatted_metadata(url)
  end

  private

  def set_spot
    # 自分のスポット以外は見られないようにする
    @spot = current_user.spots.find(params[:id])
  end

  def spot_params
    params.require(:spot).permit(
      :title,
      :url,
      :description,
      :image_url,
      :memo,
      list_ids: []
      # tag_names は後続Issueで
    )
  end

  def fetch_spots
    if @current_list
      @current_list.spots.order(created_at: :desc)
    elsif params[:list_id].present?
      current_user.spots.none
    else
      current_user.spots.order(created_at: :desc)
    end
  end

  def formatted_metadata(url)
    meta = SpotMetadataFetcher.call(url)

    {
      title: meta[:title],
      description: meta[:description],
      image_url: meta[:image_url]
    }
  end
end
