# frozen_string_literal: true

class List < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
end
