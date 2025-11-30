# frozen_string_literal: true

class Spot < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :url, presence: true
  # has_many :list_items, dependent: :destroy
  # has_many :lists, through: :list_items
end
