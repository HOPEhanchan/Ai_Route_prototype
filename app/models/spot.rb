# frozen_string_literal: true

class Spot < ApplicationRecord
  belongs_to :user

  has_many :list_items, dependent: :destroy
  has_many :lists, through: :list_items

  validates :title, presence: true
  validates :url, presence: true

  before_validation :autofill_metadata_from_url, on: :create

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
end
