# frozen_string_literal: true

class Spot < ApplicationRecord
  belongs_to :user

  has_many :list_items, dependent: :destroy
  has_many :lists, through: :list_items

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :url, presence: true

  before_validation :autofill_metadata_from_url, on: :create

  attr_writer :tag_names

  def tag_names
    @tag_names || tags.pluck(:name).join(', ')
  end

  # 保存前に tag_names 文字列 → Tag / Tagging に反映
  before_save :sync_tags_from_tag_names

  private

  def autofill_metadata_from_url
    return if url.blank?

    meta = ::SpotMetadataFetcher.call(url)

    apply_metadata(:title,       meta[:title])
    apply_metadata(:description, meta[:description])
    apply_metadata(:image_url,   meta[:image_url])
  end

  def apply_metadata(attr, value)
    return if value.blank?
    return if self[attr].present?

    self[attr] = value
  end

  # ここで tag_names をパースして Tag / Tagging を張り替える
  def sync_tags_from_tag_names
    return if @tag_names.nil?

    names = parsed_tag_names(@tag_names)

    if names.empty?
      self.tags = []
      return
    end

    self.tags = build_tags_from(names)
  end

  # "デート, 夜景  カフェ　海" みたいなのを配列にする
  def parsed_tag_names(raw)
    raw
      .split(/[,\s、\u3000]+/)
      .map(&:strip)
      .reject(&:blank?)
      .uniq
  end

  # 既存タグを使い回しつつ、足りない分は新規tagとして組み立てる
  def build_tags_from(names)
    existing = existing_tags_index(names)

    names.map do |name|
      existing[name.downcase] || Tag.new(name: name)
    end
  end

  # 大文字小文字を無視して既存tagをハッシュで引けるようにする
  def existing_tags_index(names)
    downcased = names.map(&:downcase)
    Tag.where('LOWER(name) IN (?)', downcased)
       .index_by { |t| t.name.downcase }
  end
end
