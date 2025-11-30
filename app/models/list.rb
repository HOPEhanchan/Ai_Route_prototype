# frozen_string_literal: true

class List < ApplicationRecord
  belongs_to :user

  has_many :list_items, dependent: :destroy
  has_many :spots, through: :list_items

  validates :name, presence: true
end
