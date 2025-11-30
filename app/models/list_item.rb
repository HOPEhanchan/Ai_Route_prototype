# frozen_string_literal: true

class ListItem < ApplicationRecord
  belongs_to :list
  belongs_to :spot

  validates :spot_id, uniqueness: { scope: :list_id }
end
