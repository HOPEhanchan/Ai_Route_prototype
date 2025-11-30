# frozen_string_literal: true

class Spot < ApplicationRecord
  belongs_to :user

  has_many :list_items, dependent: :destroy
  has_many :lists, through: :list_items

  validates :title, presence: true
  validates :url, presence: true
end
