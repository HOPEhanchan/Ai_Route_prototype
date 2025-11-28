# frozen_string_literal: true

class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  # has_many :spots, dependent: :destroy ← SPOTS実装後に#解除

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
end
