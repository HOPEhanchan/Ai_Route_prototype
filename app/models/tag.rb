# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :spots, through: :taggings

  validates :name,
            presence: true,
            length: { maximum: 30 },
            uniqueness: { case_sensitive: false }
end
