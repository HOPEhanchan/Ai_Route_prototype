# frozen_string_literal: true

class Tagging < ApplicationRecord
  belongs_to :spot
  belongs_to :tag

  validates :spot_id, uniqueness: { scope: :tag_id }
end
