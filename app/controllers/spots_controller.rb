# frozen_string_literal: true

class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_spot, only: %i[show edit update destroy]

  def index
    prepare_filters
    @spots = build_spot_scope.order(created_at: :desc)
  end

  def show
    # set_spot で tags / lists まで eager load 済み
    @lists         = current_user.lists.includes(:list_items)
    @spot_list_ids = @spot.list_ids
  end

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

  def edit; end

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

  # ====== OGP / メタ情報取得 (非同期用) ======
  def fetch_metadata
    url = params[:url].to_s

    if url.blank?
      render json: { error: 'URLが空です' }, status: :unprocessable_entity
      return
    end

    render json: formatted_metadata(url)
  end

  private

  # 自分のスポット以外は見られないようにする
  def set_spot
    @spot = current_user.spots
                        .includes(:tags, :lists)
                        .find(params[:id])
  end

  def spot_params
    params.require(:spot).permit(
      :title,
      :url,
      :description,
      :image_url,
      :memo,
      :tag_names,
      list_ids: []
    )
  end

  def formatted_metadata(url)
    meta = SpotMetadataFetcher.call(url)

    {
      title: meta[:title],
      description: meta[:description],
      image_url: meta[:image_url]
    }
  end

  # ====== 一覧のフィルタ用 ======

  # リスト・タグの候補を用意するだけのメソッド
  def prepare_filters
    @lists        = current_user.lists.order(created_at: :desc)
    @current_list = current_list_from_param(@lists)
    @tags         = current_user.tags.distinct.order(:name)
  end

  # list_id パラメータから「選択中リスト」を返すメソッド
  def current_list_from_param(lists)
    return if params[:list_id].blank?

    lists.find { |list| list.id == params[:list_id].to_i }
  end

  # 絞り込み用の scope を組み立てるメソッド
  def build_spot_scope
    scope = current_user.spots.includes(:tags, :lists)
    scope = filter_by_list(scope)
    filter_by_tag(scope)
  end

  def filter_by_list(scope)
    return scope if params[:list_id].blank?

    scope.joins(:lists).where(lists: { id: params[:list_id] })
  end

  def filter_by_tag(scope)
    return scope if params[:tag].blank?

    @selected_tag = Tag.find_by(name: params[:tag])
    return scope unless @selected_tag

    scope.joins(:tags).where(tags: { id: @selected_tag.id })
  end
end
