# frozen_string_literal: true

class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :spots, dependent: :destroy

  # プロフィール用バリデーション
  validates :name, length: { maximum: 50 }, allow_blank: true
  validates :profile, length: { maximum: 300 }, allow_blank: true
  validates :avatar_url, length: { maximum: 255 }, allow_blank: true

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
end
